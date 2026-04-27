import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF0A1628);
  static const Color accent = Color(0xFF1E6FD9);
  static const Color accentLight = Color(0xFF4A9FFF);
  static const Color gold = Color(0xFFD4A843);
  static const Color goldLight = Color(0xFFF0C96A);
  static const Color surface = Color(0xFF0F2040);
  static const Color cardBg = Color(0xFF162848);
  static const Color cardBg2 = Color(0xFF1A3055);
  static const Color white = Color(0xFFFFFFFF);
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white50 = Color(0x80FFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);
  static const Color pending = Color(0xFF95A5A6);
  static const Color divider = Color(0xFF1E3A5F);
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.primary,
      primaryColor: AppColors.accent,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.gold,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: GoogleFonts.playfairDisplay(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
          fontSize: 28,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),
        titleLarge: GoogleFonts.inter(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        bodyLarge: GoogleFonts.inter(
          color: AppColors.white,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.inter(
          color: AppColors.white70,
          fontSize: 14,
        ),
        bodySmall: GoogleFonts.inter(
          color: AppColors.white50,
          fontSize: 12,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.white20),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.white20),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: GoogleFonts.inter(color: AppColors.white50, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: AppColors.white70, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      useMaterial3: true,
    );
  }
}

class AppConstants {
  static const String appName = 'VIDYEN';
  //static const String appTagline = 'Knowledge. Excellence. Together.';
  static const String usersBox = 'users';
  static const String submissionsBox = 'submissions';
  static const String certificatesBox = 'certificates';
  static const String sessionBox = 'session';

  static const List<String> delegateTypes = [
    'Speaker',
    'Delegate',
    'Presenter',
    'Workshop Facilitator',
    'Moderator',
    'Observer',
  ];

  static const List<String> abstractCategories = [
    'Clinical Research',
    'Basic Science',
    'Public Health',
    'Technology & Innovation',
    'Education & Training',
    'Policy & Advocacy',
  ];

  static const List<String> workshopCategories = [
    'Hands-on Training',
    'Case Discussion',
    'Skill Workshop',
    'Panel Discussion',
    'Interactive Session',
  ];
}