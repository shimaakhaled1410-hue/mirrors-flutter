import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF3B2A4A);
  static const Color primaryLight = Color(0xFF7D5F94);
  static const Color accent = Color(0xFFB0616D);
  static const Color accentSoft = Color(0xFFE6A9B2);

  static const Color lightBackground = Color(0xFFF8F4F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF241A2C);
  static const Color lightTextSecondary = Color(0xFF7A6E82);
  static const Color lightBorder = Color(0xFFEADFE4);

  static const Color darkBackground = Color(0xFF150F1A);
  static const Color darkSurface = Color(0xFF211A29);
  static const Color darkTextPrimary = Color(0xFFF4EEF6);
  static const Color darkTextSecondary = Color(0xFFB3A6BC);
  static const Color darkBorder = Color(0xFF362B41);

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
    colors: [accent, Color(0xFFD48F98)],
  );
}