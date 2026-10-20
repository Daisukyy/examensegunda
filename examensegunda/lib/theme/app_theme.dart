import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const cream = Color(0xFFFFF8F2);
  static const pink = Color(0xFFFF9EC4);
  static const hotPink = Color(0xFFFF6FA5);
  static const lavender = Color(0xFFB79CFF);
  static const paleLavender = Color(0xFFE4D8FF);
  static const mint = Color(0xFFCFF5E4);
  static const ink = Color(0xFF5A4670);
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: hotPink, primary: hotPink, secondary: lavender, surface: cream),
        textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: ink, displayColor: ink),
        appBarTheme: const AppBarTheme(backgroundColor: cream, foregroundColor: ink, centerTitle: false),
        inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: paleLavender)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: paleLavender)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: hotPink, width: 1.5))),
      );
}
