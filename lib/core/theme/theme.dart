import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData myTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
