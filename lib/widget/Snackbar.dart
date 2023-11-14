// ignore_for_file: file_names

import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      closeIconColor: Colors.white,
      showCloseIcon: true,
    ),
  );
}
