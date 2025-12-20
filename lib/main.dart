import 'package:flutter/material.dart';
import 'package:holocron/src/config/theme/app_theme.dart';
import 'package:holocron/src/presentation/pages/main/main_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Holocron',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainPage(),
    );
  }
}
