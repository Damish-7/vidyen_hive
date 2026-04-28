// lib/utils/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // 🔷 Brand Colors (Premium feel)
  static const Color primary     = Color(0xFF0F172A); // Deep Navy (main brand)
  static const Color secondary   = Color(0xFF1E3A8A); // Rich Blue
  static const Color accent      = Color(0xFF3B82F6); // Vibrant Blue
  static const Color highlight   = Color(0xFF22D3EE); // Cyan glow (modern touch)

  // 🤍 Backgrounds (clean but not flat)
  static const Color background  = Color(0xFFF8FAFC); // Soft white (not harsh)
  static const Color surface     = Color(0xFFFFFFFF); // pure white
  static const Color cardBg      = Color(0xFFFFFFFF); // card base
  static const Color inputBg     = Color(0xFFF1F5F9); // subtle input

  // 📝 Text (balanced contrast)
  static const Color textPrimary   = Color(0xFF0F172A); // dark navy
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted     = Color(0xFF94A3B8);

  // 🚦 Status (slightly modern tones)
  static const Color success = Color(0xFF10B981);
  static const Color error   = Color(0xFFF43F5E);
  static const Color warning = Color(0xFFF59E0B);

  // 🌈 Gradients (THIS makes UI attractive)
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF1E3A8A),
      Color(0xFF3B82F6),
    ],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E3A8A),
      Color(0xFF3B82F6),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF8FAFC),
    ],
  );
}