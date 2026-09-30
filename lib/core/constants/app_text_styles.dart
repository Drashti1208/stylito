import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings
  static TextStyle heading1 = GoogleFonts.montserrat(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static TextStyle heading2 = GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static TextStyle heading3 = GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  // Subtitles & Body
  static TextStyle subHeading = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static TextStyle body = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textBody,
  );

  static TextStyle bodyMedium = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textBody,
  );

  static TextStyle bodyBold = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static TextStyle caption = GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );

  // Button style
  static TextStyle button = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Price styles
  static TextStyle price = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static TextStyle originalPrice = GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
    decoration: TextDecoration.lineThrough,
  );

  static TextStyle discount = GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.discountTag,
  );
}
