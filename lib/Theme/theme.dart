import 'package:flutter/material.dart';


class AppTheme {
  static const Color primary = Color(0xFF5C2E91);
  static const Color primarySoft = Color(0xFFEDE7FF);
  static const Color accent = Color(0xFFEE8A41);
  static const Color green = Color(0xFF3DB38D);
  static const Color bg = Color(0xFFF5F3FF);
  static const String fontFamily = 'ClashGrotesk';

  static ThemeData get lightTheme {
    final base = ThemeData.light();

    return base.copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: bg,
      primaryColor: primary,
      colorScheme: base.colorScheme.copyWith(
        primary: primary,
        secondary: accent,
        background: bg,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: base.textTheme.apply(
        fontFamily: fontFamily,
        bodyColor: const Color(0xFF1E1E1E),
        displayColor: const Color(0xFF1E1E1E),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(
          fontFamily: fontFamily,
          color: Colors.grey.shade500,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.3),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

