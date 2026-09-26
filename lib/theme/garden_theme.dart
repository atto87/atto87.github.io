import 'package:flutter/material.dart';

/// Shared colors and controls for the botanical notebook interface.
abstract final class GardenTheme {
  static const ink = Color(0xFF263E35);
  static const green = Color(0xFF35634D);
  static const paper = Color(0xFFFAF8F2);
  static const rose = Color(0xFFB65B73);
  static const line = Color(0xFFE2E6DA);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: green).copyWith(
      primary: green,
      onPrimary: Colors.white,
      secondary: rose,
      surface: paper,
      onSurface: ink,
      primaryContainer: const Color(0xFFE7EEDC),
      outline: const Color(0xFF879488),
    );
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    return base.copyWith(
      scaffoldBackgroundColor: paper,
      textTheme: base.textTheme.apply(bodyColor: ink, displayColor: ink),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: paper,
        foregroundColor: ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: ink,
            letterSpacing: 1),
      ),
      filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      )),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        foregroundColor: ink,
        side: const BorderSide(color: line),
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      )),
      tabBarTheme: const TabBarThemeData(
        labelColor: green,
        unselectedLabelColor: Color(0xFF788276),
        indicatorColor: green,
        dividerColor: line,
        labelStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: green,
        linearTrackColor: Color(0xFFE2E9DB),
      ),
    );
  }
}
