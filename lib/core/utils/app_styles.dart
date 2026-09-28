import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppStyles {
  AppStyles._();

  static String get fontFamily => GoogleFonts.cairo().fontFamily!;

  static TextStyle bold18(BuildContext context) => GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle bold20(BuildContext context) => GoogleFonts.cairo(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle semiBold16(BuildContext context) => GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );
  static TextStyle bold16(BuildContext context) => GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle medium14(BuildContext context) => GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle regular14(BuildContext context) => GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Theme.of(context).brightness == Brightness.light
        ? AppColors.lightTextSecondary
        : AppColors.darkTextSecondary,
  );

  static TextStyle regular12(BuildContext context) => GoogleFonts.cairo(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Theme.of(context).brightness == Brightness.light
        ? AppColors.lightTextSecondary
        : AppColors.darkTextSecondary,
  );

  static TextStyle bold16Accent = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.accent,
  );
}
