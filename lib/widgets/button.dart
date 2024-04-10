import 'package:flutter/material.dart';

Widget newButton({
  required String title,
  required Function callback,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: () {
      callback();
    },
    child: SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.75,
      child: Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(106, 176, 137, 1),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              width: 4,
              color: Colors.white,
            ),
          ),
          child: Center(
              child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ))),
    ),
  );
}
