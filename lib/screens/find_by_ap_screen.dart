// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:snake_tail/screens/details_screen.dart';
import 'package:snake_tail/screens/no_result.dart';
import 'package:snake_tail/utils/snake.dart';
import 'package:snake_tail/widgets/appbar.dart';
import 'package:snake_tail/widgets/button.dart';
import 'package:http/http.dart' as http;

const apiURL = 'http://34.143.254.211:8080';

class FindByAppearanceScreen extends StatefulWidget {
  const FindByAppearanceScreen({super.key});

  @override
  State<FindByAppearanceScreen> createState() => _FindByAppearanceScreenState();
}

Future<List<String>?> getFirstAid() async {
  try {
    final response = await http.get(Uri.parse('$apiURL/getFirstAid'));

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);

      if (data is Map<String, dynamic> && data.containsKey('first_aid_steps')) {
        // Extract first aid steps from the response
        List<dynamic> firstAidData = data['first_aid_steps'];
        List<String> firstAidSteps =
            firstAidData.map((item) => item.toString()).toList();
        print('First aid steps fetched successfully!');
        return firstAidSteps;
      } else {
        // Unexpected response format
        print('Unexpected response format for first aid steps: $data');
        return null;
      }
    } else {
      print('Failed to fetch first aid steps: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching first aid steps: $e');
    return null;
  }
}

class _FindByAppearanceScreenState extends State<FindByAppearanceScreen> {
  void openDetails(Snake snake) {
    print("Opening details screen...");
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DetailsScreen(
        snake: snake,
      ),
    ));
  }

  void newOpenDetails() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const NoResultsScreen(),
    ));
  }

  String headshape = '';
  String skin_color = '';
  String skin_pattern = '';

  final List<String> heads = List.empty(growable: true);
  final List<String> skinColor = List.empty(growable: true);
  final List<String> skinPattern = List.empty(growable: true);

  Future<void> sendData(BuildContext c) async {
    print('Sending data to the API...');

    // Create JSON request body
    Map<String, dynamic> requestBody = {
      "fields": {
        "skin_color": skin_color,
        "skin_pattern": skin_pattern,
        "head_shape": headshape
      }
    };

    // Convert request body to JSON string
    String jsonBody = jsonEncode(requestBody);

    try {
      final response = await http.post(
        Uri.parse('$apiURL/snakes/spec'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print('Response received successfully!');

        print(response.body);
        var jsonResponse = response.body;

        print('Response: $jsonResponse');

        if (jsonResponse == 'unknown') {
          newOpenDetails();
          return;
        }

        var newReq = await http.get(Uri.parse('$apiURL/snakes/$jsonResponse'));
        print("New Request: $newReq");

        if (newReq.statusCode == 200) {
          Map<String, dynamic> newJsonResponse = json.decode(newReq.body);

          String snakeName =
              newJsonResponse['fields']['snake_name']['stringValue'];
          String description =
              newJsonResponse['fields']['description']['stringValue'];
          String scientificName =
              newJsonResponse['fields']['scientific_name']['stringValue'];
          String imageUrl =
              newJsonResponse['fields']['image_url']['stringValue'];

          print('Snake Name: $snakeName');
          print('Description: $description');
          print('Scientific Name: $scientificName');
          print('Image URL: $imageUrl');

          // Retrieve medicine
          List<String>? medicine = await getFirstAid();

          if (medicine != null) {
            print('Medicine: $medicine');
            openDetails(Snake(
                snakeName, description, medicine, scientificName, imageUrl));
          } else {
            print('Failed to retrieve medicine.');
          }
        }
      } else {
        print('Failed to send data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  Future<bool?> getHeadShapes() async {
    try {
      final response = await http.get(Uri.parse('$apiURL/getHeadShapes'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        heads.clear();
        heads.addAll(data.map((item) => item.toString()));
        print('Head shapes fetched successfully!');
        return true;
      } else {
        print('Failed to fetch head shapes: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error fetching head shapes: $e');
      return false;
    }
  }

  Future<bool?> getSkinColor() async {
    try {
      final response = await http.get(Uri.parse('$apiURL/getSkinColor'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        skinColor.clear();
        skinColor.addAll(data.map((item) => item.toString()));
        print('Skin colors fetched successfully!');
        return true;
      } else {
        print('Failed to fetch skin colors: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error fetching skin colors: $e');
      return false;
    }
  }

  Future<bool?> getSkinPattern() async {
    try {
      final response = await http.get(Uri.parse('$apiURL/getSkinPattern'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        skinPattern.clear();
        skinPattern.addAll(data.map((item) => item.toString()));
        print('skin patterns fetched successfully!');
        return true;
      } else {
        print('Failed to fetch skin patterns: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error fetching skin patterns: $e');
      return false;
    }
  }

  Future<bool?> getdata() async {
    try {
      // Fetch head shapes
      bool? headShapesSuccess = await getHeadShapes();
      // Fetch skin colors
      bool? skinColorsSuccess = await getSkinColor();
      // Fetch skin patterns
      bool? skinPatternsSuccess = await getSkinPattern();

      return headShapesSuccess != null &&
          skinColorsSuccess != null &&
          skinPatternsSuccess != null &&
          headShapesSuccess &&
          skinColorsSuccess &&
          skinPatternsSuccess;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: create_green_appbar(title: "Find By Appearance"),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getdata(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                    child: Column(
                  children: [
                    CircularProgressIndicator(),
                  ],
                ));
              case ConnectionState.done:
                return Stack(
                  children: [
                    Image.asset(
                      'assets/images/logobg.png',
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 40,
                        left: 20,
                        right: 20,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Head Shape",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 23),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            DropdownMenu<String>(
                              menuStyle: const MenuStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color.fromARGB(255, 228, 249, 228))),
                              initialSelection: headshape,
                              onSelected: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  headshape = value!;
                                });
                              },
                              dropdownMenuEntries: heads
                                  .map<DropdownMenuEntry<String>>(
                                      (String value) {
                                return DropdownMenuEntry<String>(
                                    value: value, label: value);
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            const Text(
                              "Skin Color",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 23),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            DropdownMenu<String>(
                              menuStyle: const MenuStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color.fromARGB(255, 228, 249, 228))),
                              initialSelection: skin_color,
                              onSelected: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  skin_color = value!;
                                });
                              },
                              dropdownMenuEntries: skinColor
                                  .map<DropdownMenuEntry<String>>(
                                      (String value) {
                                return DropdownMenuEntry<String>(
                                  value: value,
                                  label: value,
                                );
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            const Text(
                              "Skin Pattern",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 23),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            DropdownMenu(
                              menuStyle: const MenuStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color.fromARGB(255, 228, 249, 228))),
                              initialSelection: skin_pattern,
                              onSelected: (String? value) {
                                setState(() {
                                  skin_pattern = value!;
                                });
                              },
                              dropdownMenuEntries: skinPattern
                                  .map<DropdownMenuEntry<String>>(
                                      (String value) {
                                return DropdownMenuEntry<String>(
                                  value: value,
                                  label: value,
                                );
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            newButton(
                              title: "Submit",
                              callback: () {
                                sendData(context);
                              },
                              context: context,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              case ConnectionState.none:
                // TODO: Handle this case.
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              // TODO: Handle this case.
            }

            return const Center(child: Text('Error'));
          },
        ),
      ),
    );
  }
}
