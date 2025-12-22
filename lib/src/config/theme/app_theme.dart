import 'package:flutter/material.dart';

abstract class AppTheme {
  // Star Wars Color Palette
  static const Color spaceBlack = Color(0xFF0A0E27);
  static const Color imperialYellow = Color(0xFFFFE81F);
  static const Color holoBlue = Color(0xFF4DA6FF);
  static const Color darkGray = Color(0xFF1A1D2E);
  static const Color lightGray = Color(0xFFB8B8B8);
  static const Color accentRed = Color(0xFFFF3D00);
  static const Color deepSpace = Color(0xFF050811);
  static const Color cardBackground = Color(0xFF141828);
  static const Color terminalGreen = Color(0xFF00FF88);

  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
    color: imperialYellow,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.8,
    color: Colors.white,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: Colors.white,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: lightGray,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: lightGray,
  );

  static ThemeData get lightTheme => darkTheme;

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: spaceBlack,
    primaryColor: imperialYellow,
    colorScheme: const ColorScheme.dark(
      primary: imperialYellow,
      secondary: holoBlue,
      surface: darkGray,
      error: accentRed,
    ),
    cardTheme: const CardThemeData(
      color: cardBackground,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: heading2,
    ),
    textTheme: const TextTheme(
      displayLarge: heading1,
      displayMedium: heading2,
      displaySmall: heading3,
      bodyLarge: bodyText,
      bodyMedium: bodyText,
      labelSmall: caption,
    ),
  );
}
