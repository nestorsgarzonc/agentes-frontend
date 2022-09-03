import 'package:flutter/material.dart';

class CustomSnackbar {
  static ScaffoldFeatureController showSnackBar(BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
