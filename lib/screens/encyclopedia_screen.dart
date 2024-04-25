import 'package:flutter/material.dart';
import 'package:snake_tail/screens/details_screen.dart';
import 'package:snake_tail/screens/find_by_ap_screen.dart';
import 'package:snake_tail/utils/snake.dart';
import 'package:snake_tail/widgets/appbar.dart';
import 'package:snake_tail/widgets/button.dart';
import 'dart:convert'; // for json decoding
import 'package:http/http.dart' as http;

const apiURL = 'http://localhost:8080';

class EncylopediaScreen extends StatefulWidget {
  const EncylopediaScreen({super.key});

  @override
  State<EncylopediaScreen> createState() => _EncylopediaScreenState();
}

class _EncylopediaScreenState extends State<EncylopediaScreen> {
  void openDetails(Snake snake) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DetailsScreen(
        snake: snake,
      ),
    ));
  }

  List<Snake> allsnakes = List.empty(growable: true);

  Future<bool> getSnakes() async {
    try {
      final response = await http.get(
        Uri.parse('$apiURL/snakes'),
      );

      if (response.statusCode == 200) {
        // Parse JSON response
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Check if the response contains a 'documents' key that holds an array of snakes
        if (jsonResponse.containsKey('documents')) {
          List<dynamic> snakesData = jsonResponse['documents'];

          // Iterate over each snake object in the response
          for (var snakeData in snakesData) {
            Map<String, dynamic> fields = snakeData['fields'];
            List<String>? medicine = await getFirstAid();

            // Extract fields from JSON
            String snakeName = fields['snake_name']['stringValue'];
            String description = fields['description']['stringValue'];
            String scientificName = fields['scientific_name']['stringValue'];
            String imageUrl = fields['image_url']['stringValue'];

            // Create Snake object
            Snake snake = Snake(
              snakeName,
              description,
              medicine, // empty medicine list for now
              scientificName,
              imageUrl,
            );

            allsnakes.add(snake);

            // Print fields to console
            print('Snake Name: $snakeName');
            print('Description: $description');
            print('Scientific Name: $scientificName');
            print('Image URL: $imageUrl');
          }
        } else {
          print('Error: No "documents" key found in the response');
        }
      } else {
        // Handle other status codes if needed
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occurred during the API call
      print('Error: ${e.toString()}');
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: create_green_appbar(title: "Encyclopedia"),
      body: SingleChildScrollView(
          child: Expanded(
        child: Center(
          child: Stack(
            children: [
              Image.asset(
                "assets/images/background.png",
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Center(
                  child: FutureBuilder(
                    future: getSnakes(),
                    builder: (context, snapshot) => snapshot.connectionState ==
                            ConnectionState.waiting
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: allsnakes
                                .asMap()
                                .entries
                                .map((e) => Container(
                                      padding: const EdgeInsets.all(10),
                                      child: newButton(
                                        title: e.value.snake_name,
                                        callback: () {
                                          openDetails(e.value);
                                        },
                                        context: context,
                                      ),
                                      // child: newButton(
                                      //   title: e.value.snake_name,
                                      //   callback: () {
                                      //     openDetails(
                                      //       e.value,
                                      //     );
                                      //   },
                                      //   context: context,
                                      // ),
                                    ))
                                .toList(),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
