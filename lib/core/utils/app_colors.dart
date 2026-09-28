import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF2C3E50);
  static const Color primaryLight = Color(0xFF4A6572);
  static const Color accent = Color(0xFFD4AF37);

  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1E272E);
  static const Color lightTextSecondary = Color(0xFF718093);
  static const Color lightBorder = Color(0xFFE2E8F0);

  static const Color darkBackground = Color(0xFF121417);
  static const Color darkSurface = Color(0xFF1E232A);
  static const Color darkTextPrimary = Color(0xFFF1F2F6);
  static const Color darkTextSecondary = Color(0xFFA4B0BE);
  static const Color darkBorder = Color(0xFF2F3640);

  static const Color success = Color(0xFF2ED573);
  static const Color warning = Color(0xFFFFA502);
  static const Color error = Color(0xFFFF4757);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, Color(0xFFE8CB63)],
  );
}