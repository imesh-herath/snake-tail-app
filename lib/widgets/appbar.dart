import 'package:flutter/material.dart';

AppBar create_green_appbar({required String title}) {
  return AppBar(
    backgroundColor: Colors.green[500],
    title: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
    centerTitle: true,
  );
}
