import 'package:flutter/material.dart';
import 'package:snake_tail/screens/questions_screen.dart';
import 'package:snake_tail/utils/snake.dart';
import 'package:snake_tail/widgets/appbar.dart';

class DetailsScreen extends StatelessWidget {
  final Snake snake;
  const DetailsScreen({super.key, required this.snake});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2;
    return Scaffold(
      appBar: create_green_appbar(title: "Results"),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              "assets/images/background.png",
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        Uri.parse(snake.img_url).toString(),
                        width: width,
                        fit: BoxFit.fill,
                        scale: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snake.snake_name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                            Text(snake.scientific_name ?? ''),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    snake.discription,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'First Aid',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: snake.medicine.asMap().entries.map((e) {
                        int index = e.key;
                        return Text('${index + 1}. ${e.value}');
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Are you bitten by a snake?",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle "Yes" button press
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const QuestionsScreen(),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow),
                          child: const Text(
                            'Yes',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Handle "No" button press
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow),
                          child: const Text(
                            'No',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
