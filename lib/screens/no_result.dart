import 'package:flutter/material.dart';
import 'package:snake_tail/widgets/appbar.dart';

class NoResultsScreen extends StatelessWidget {
  const NoResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: create_green_appbar(title: "No Results!"),
        body: Center(
          child: Stack(children: [
            Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'No results found for the image you uploaded',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Try again with a different image',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ]),
        ));
  }
}
