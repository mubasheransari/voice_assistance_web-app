import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFFE53935);
  static const Color primaryDark = Color(0xFFB71C1C);
  static const Color bgWhite = Colors.white;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: primaryDark,
      background: bgWhite,
    ),
    scaffoldBackgroundColor: bgWhite,
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.red.withOpacity(0.02),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primary, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.red.shade100, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primary, width: 1.4),
      ),
      labelStyle: const TextStyle(color: primary),
    ),
    // cardTheme: CardTheme(
    //   color: Colors.white,
    //   elevation: 4,
    //   shadowColor: Colors..withOpacity(0.1),
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(18),
    //   ),
    // ),
  );
}
