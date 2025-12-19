import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData get lightTheme => ThemeData(primarySwatch: Colors.blue);

  static ThemeData get darkTheme => ThemeData(primarySwatch: Colors.blue);
}
