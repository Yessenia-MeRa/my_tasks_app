import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primarySwatch: Colors.red,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF8490D5),
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF8490D5),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
  );
}