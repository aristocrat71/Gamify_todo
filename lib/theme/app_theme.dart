import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // --- Core colors ---
  static const Color xpAmber = Color(0xFFFFA726);
  static const Color successGreen = Color(0xFF66BB6A);
  static const Color penaltyRed = Color(0xFFEF5350);
  static const Color levelPurple = Color(0xFFAB47BC);
  static const Color streakOrange = Color(0xFFFF7043);
  static const Color surface = Color(0xFF1E1E2E);
  static const Color surfaceLight = Color(0xFF2A2A3C);
  static const Color textPrimary = Color(0xFFE0E0E0);
  static const Color textSecondary = Color(0xFF9E9E9E);

  // --- Difficulty colors ---
  static const Color easyGreen = Color(0xFF4CAF50);
  static const Color mediumOrange = Color(0xFFFF9800);
  static const Color hardRed = Color(0xFFF44336);

  static Color difficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return easyGreen;
      case 'hard':
        return hardRed;
      default:
        return mediumOrange;
    }
  }

  // --- Theme data ---
  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.pressStart2pTextTheme(
      ThemeData.dark().textTheme,
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121220),
      textTheme: baseTextTheme,
      colorScheme: const ColorScheme.dark(
        primary: xpAmber,
        secondary: levelPurple,
        surface: surface,
        error: penaltyRed,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.pressStart2p(
          color: textPrimary,
          fontSize: 14,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceLight,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: xpAmber,
        foregroundColor: Color(0xFF121220),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: xpAmber,
        unselectedItemColor: textSecondary,
        selectedLabelStyle: GoogleFonts.pressStart2p(fontSize: 7),
        unselectedLabelStyle: GoogleFonts.pressStart2p(fontSize: 7),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceLight,
        contentTextStyle: GoogleFonts.pressStart2p(color: textPrimary, fontSize: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
