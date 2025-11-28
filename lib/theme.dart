import 'package:flutter/material.dart';

ThemeData buildTheme() {
  const primary = Color(0xFFFF7A21);
  const bg = Color(0xFF0E0E0E);
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme.dark(
      primary: primary,
      secondary: Colors.white,
      background: bg,
      surface: const Color(0xFF161616),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF161616),
      elevation: 0,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1F1F1F),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF161616),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    ),
  );
}
