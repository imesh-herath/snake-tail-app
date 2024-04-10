import 'package:flutter/material.dart';
import 'package:snake_tail/widgets/appbar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: create_green_appbar(title: "About"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Center(
              child: Stack(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logobg.png',
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'VICTRIC a group of 2nd year undergraduate students who are following Beng (Hons) Software Engineering degree program at Informatics of Technology(IIT). associated with the University of Westminister.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    const Text(
                      "Developer",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 23),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: CircleAvatar(
                        minRadius: 5,
                        child: Image.asset(
                          'assets/images/profile.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "Imash Herath",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 23),
                    ),
                  ],
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
