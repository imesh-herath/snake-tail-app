import 'package:flutter/material.dart';
import 'package:snake_tail/screens/map_screen.dart';
import 'package:snake_tail/widgets/appbar.dart';
import 'package:snake_tail/widgets/button.dart';

class ConfirmScreen extends StatelessWidget {
  const ConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: create_green_appbar(title: 'Thank you!'),
      body: Center(
        child: Stack(
          children: [
            Image.asset(
              "assets/images/logobg.png",
              fit: BoxFit.fill,
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "THANK YOU FOR YOUR SUPPORT!",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: newButton(
                      title: "Get Geo location to nearst hospital",
                      callback: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MapScreen(),
                        ));
                      },
                      context: context,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
