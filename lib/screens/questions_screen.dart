import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:snake_tail/screens/confirm_screen.dart';
import 'package:snake_tail/widgets/appbar.dart';
import 'package:snake_tail/widgets/button.dart';
import 'package:http/http.dart' as http;

const apiURL = 'http://34.143.254.211:8080';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  @override
  Widget build(BuildContext context) {
    //submit function

    String sickness = '';
    String experiencing = '';
    String breathing = '';
    String bleeding = '';
    String changes = '';
    String bittenTime = '';
    String name = '';

    void press() async {
      try {
        // Prepare the JSON payload
        Map<String, dynamic> requestBody = {
          'fields': {
            'sickness': {'stringValue': sickness},
            'experiencing': {'stringValue': experiencing},
            'breathing': {'stringValue': breathing},
            'bleeding': {'stringValue': bleeding},
            'changes': {'stringValue': changes},
            'bittenTime': {'timestampValue': bittenTime},
            'name': {'stringValue': name},
          }
        };

        print(requestBody);

        // Encode the JSON payload
        String jsonPayload = jsonEncode(requestBody);

        // Make the API call
        var response = await http.post(
          Uri.parse('$apiURL/patient'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonPayload,
        );

        // Handle the response
        if (response.statusCode == 200) {
          // API call successful
          print('API call successful');
        } else {
          // API call failed
          print('Failed to make API call: ${response.statusCode}');
        }
      } catch (e) {
        // Handle errors
        print('Error occurred: $e');
      } finally {
        // Navigate to next screen
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ConfirmScreen(),
        ));
      }
    }

    return Scaffold(
      appBar: create_green_appbar(title: "Quick Questions!"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Answer the below questions to get better treatment',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Bitten Time'),
                    TextButton(
                      onPressed: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );

                        setState(() {
                          bittenTime = selectedTime.toString();
                        });
                      },
                      child: const Text("select time"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('What is your name?'),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter your name', // Placeholder text
                      ),
                      onChanged: (value) {
                        setState(() {
                          name =
                              value; // Update the changes variable with the entered value
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        'Are you feeling any pain,swelling or redness around the bite area ?'),
                    DropdownMenu(
                      label: const Text('No'),
                      initialSelection: "No",
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(label: 'No', value: 'No'),
                        DropdownMenuEntry(label: 'Pain', value: 'Pain'),
                        DropdownMenuEntry(label: 'Swelling', value: 'swelling'),
                        DropdownMenuEntry(
                            label: 'Rediness around the bite area',
                            value: 'rediness around the bite area'),
                      ],
                      onSelected: (value) {
                        setState(() {
                          experiencing = value.toString();
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        'Do you have any dizziness, nausea or vomiting ?'),
                    DropdownMenu(
                      label: const Text('No'),
                      initialSelection: "No",
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(label: 'No', value: 'No'),
                        DropdownMenuEntry(
                            label: 'dizziness', value: 'dizziness'),
                        DropdownMenuEntry(label: 'nausea', value: 'nausea'),
                        DropdownMenuEntry(
                            label: 'vommiting', value: 'vommiting'),
                      ],
                      onSelected: (value) {
                        setState(() {
                          sickness = value.toString();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Are you having trouble breathing ?'),
                    DropdownMenu(
                      label: const Text('No'),
                      initialSelection: "No",
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(label: 'No', value: 'No'),
                        DropdownMenuEntry(label: 'Yes', value: 'Yes'),
                      ],
                      onSelected: (value) {
                        setState(() {
                          breathing = value.toString();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        'Do you have any bleeding from the bite wound ?'),
                    DropdownMenu(
                      label: const Text('No'),
                      initialSelection: "No",
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(label: 'No', value: 'No'),
                        DropdownMenuEntry(label: 'Yes', value: 'Yes'),
                      ],
                      onSelected: (value) {
                        setState(() {
                          bleeding = value.toString();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Do you have any change in vision or speach ?'),
                    DropdownMenu(
                      label: const Text('No'),
                      initialSelection: "No",
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(label: 'No', value: 'No'),
                        DropdownMenuEntry(label: 'Yes', value: 'Yes'),
                      ],
                      onSelected: (value) {
                        setState(() {
                          changes = value.toString();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    newButton(
                      title: "Submit",
                      callback: () {
                        press();
                      },
                      context: context,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
