import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourist_app/core/utils/app_colors.dart';


class AppStyles {
  static TextStyle mediume24White = GoogleFonts.inter(
    color: AppColors.whiteColor,
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );
  static TextStyle lightGray12Regular = GoogleFonts.inter(
    color: AppColors.lightGrayColor,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  static TextStyle lightGray14Regular = GoogleFonts.inter(
    color: AppColors.lightGrayColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static TextStyle primary12Medium = GoogleFonts.inter(
    color: AppColors.primaryColor,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  static TextStyle primary16Medium = GoogleFonts.inter(
    color: AppColors.primaryColor,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static TextStyle primary18Medium = GoogleFonts.inter(
    color: AppColors.primaryColor,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  static TextStyle primary24semiBold = GoogleFonts.inter(
    color: AppColors.primaryColor,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  static TextStyle yellow14mediume = GoogleFonts.inter(
    color: AppColors.yellowColor,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}
