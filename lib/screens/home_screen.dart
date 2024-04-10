import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snake_tail/screens/details_screen.dart';
// import 'package:snake_tail/screens/details_screen.dart';
import 'package:snake_tail/screens/encyclopedia_screen.dart';
import 'package:snake_tail/screens/find_by_ap_screen.dart';
import 'package:snake_tail/screens/map_screen.dart';
import 'package:snake_tail/screens/no_result.dart';
import 'package:snake_tail/utils/snake.dart';
// import 'package:snake_tail/utils/snake.dart';
import 'package:snake_tail/widgets/appbar.dart';
import 'package:snake_tail/widgets/button.dart';
import 'package:http/http.dart' as http;

const apiURL = 'http://34.143.254.211:8080';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void openDetails(Snake snake) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DetailsScreen(
        snake: snake,
      ),
    ));
  }
  // void openDetails() {
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) => NoResultsScreen(
  //     ),
  //   ));
  // }

  Future<void> pickImage(ImageSource fromWhere) async {
    final picker = ImagePicker();
    XFile? image = await picker.pickImage(source: fromWhere);

    if (image == null) {
      // Handle if user didn't pick an image
      print("No image selected");
      return;
    }

    String snake_name, discription, scientific_name, img_url;
    List<String> medicines = [];

    // Read image file as bytes
    List<int> imageBytes = await image.readAsBytes();

    // Prepare the request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiURL/snakes/img'),
    );

    // Add the image bytes to the request
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'image.jpg', // Set the filename here
      ),
    );

    // Send the request
    try {
      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        // If the request was successful, decode the response
        var response = await streamedResponse.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(response);

        // Extract data from the response
        String snakeName = jsonResponse['fields']['snake_name']['stringValue'];
        String description =
            jsonResponse['fields']['description']['stringValue'];
        String scientificName =
            jsonResponse['fields']['scientific_name']['stringValue'];
        String imageUrl = jsonResponse['fields']['image_url']['stringValue'];

        // Do whatever you need with the data
        print('Snake Name: $snakeName');
        print('Description: $description');
        print('Scientific Name: $scientificName');
        print('Image URL: $imageUrl');

        openDetails(
            Snake(snakeName, description, [], scientificName, imageUrl));
      } else {
        // Handle other status codes if needed
        print('Failed to fetch data: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occurred during the API call
      print('Error: $e');
    }
  }

  void naviagate({required Widget to}) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => to,
    ));
  }

  void p() {
    print('hello world sddsf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: create_green_appbar(title: "Home"),
      body: Center(
        child: Stack(children: [
          Center(
            child: Image.asset(
              "assets/images/logobg.png",
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                newButton(
                  title: "Camera",
                  callback: () => pickImage(ImageSource.camera),
                  context: context,
                ),
                const SizedBox(
                  height: 30,
                ),
                newButton(
                    title: "Upload an image",
                    callback: () {
                      pickImage(ImageSource.gallery);
                    },
                    context: context),
                const SizedBox(
                  height: 30,
                ),
                newButton(
                    title: "Find by Appearance",
                    callback: () {
                      naviagate(
                        to: const FindByAppearanceScreen(),
                      );
                    },
                    context: context),
                const SizedBox(
                  height: 30,
                ),
                newButton(
                    title: "Encyclopedia",
                    callback: () {
                      naviagate(
                        to: const EncylopediaScreen(),
                      );
                    },
                    context: context),
                const SizedBox(
                  height: 30,
                ),
                newButton(
                    title: "Map",
                    callback: () {
                      naviagate(
                        to: const MapScreen(),
                      );
                    },
                    context: context),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
