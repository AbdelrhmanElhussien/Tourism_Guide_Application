import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color blackColor = Color(0xff121312);
  static const Color whiteColor = Color(0xffffffff);
  static const Color begiColor = Color(0xffF5E6C8);
  static const Color yellowColor = Color(0xffC9A646);
  static const Color lightyellowColor = Color(0xffF5E6C8);
  static const Color lightGrayColor = Color(0xff6B7280);
  static const Color primaryColor = Color(0xff1E3A5F);
  static const Color darkBlueColor = Color(0xff0B1825);
  static const Color cardColor = Color(0x661e3a5f);
  static const Color bottomNavigationColor = Color(0xff162535);
  static const Color blueColor = Color(0xff9EB3C8);
  // ── Design tokens (matching the screenshot) ──
  static const Color gold = Color(0xFFB8963E);
  static const Color hint = Color(0xFFAAAAAA);
  static const Color border = Color(0xFFDDDDDD);
  static const Color socialBorder = Color(0xFFE0E0E0);
  static const Color subText = Color(0xFF888888);
}

class AppStyles {
  static TextStyle mediume24White = GoogleFonts.inter(
    color: AppColors.whiteColor,
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );
  static TextStyle semiBold30Black = GoogleFonts.inter(
    color: AppColors.blackColor,
    fontSize: 30,
    fontWeight: FontWeight.w500,
  );
  static TextStyle semiBold30Bagi = GoogleFonts.inter(
    color: AppColors.begiColor,
    fontSize: 30,
    fontWeight: FontWeight.w500,
  );
  static TextStyle regular16lightBlue = GoogleFonts.inter(
    color: AppColors.blueColor,
    fontSize: 16,
    fontWeight: FontWeight.w300,
  );
  static TextStyle regular16balck = GoogleFonts.inter(
    color: AppColors.blackColor,
    fontSize: 16,
    fontWeight: FontWeight.w200,
  );

  static TextStyle medium14Bagi = GoogleFonts.inter(
    color: AppColors.begiColor,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static TextStyle medium14black = GoogleFonts.inter(
    color: AppColors.blackColor,
    fontSize: 14,
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
  static TextStyle lightYellow18Medium = GoogleFonts.inter(
    color: AppColors.lightyellowColor,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  static TextStyle primary24semiBold = GoogleFonts.inter(
    color: AppColors.primaryColor,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  static TextStyle primary30semiBold = GoogleFonts.inter(
    color: AppColors.primaryColor,
    fontSize: 30,
    fontWeight: FontWeight.w600,
  );
  static TextStyle white30semiBold = GoogleFonts.inter(
    color: AppColors.primaryColor,
    fontSize: 30,
    fontWeight: FontWeight.w600,
  );
  static TextStyle lightYellow24semiBold = GoogleFonts.inter(
    color: AppColors.lightyellowColor,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  static TextStyle yellow14mediume = GoogleFonts.inter(
    color: AppColors.yellowColor,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static TextStyle blue14mediume = GoogleFonts.inter(
    color: AppColors.blueColor,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static TextStyle black14mediume = GoogleFonts.inter(
    color: AppColors.blackColor,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColor,
    ),
    cardColor: AppColors.whiteColor,
    scaffoldBackgroundColor: AppColors.whiteColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.whiteColor,
      selectedItemColor: AppColors.yellowColor,
      unselectedItemColor: AppColors.lightGrayColor,
      selectedLabelStyle: AppStyles.primary12Medium.copyWith(color: AppColors.yellowColor),
      unselectedLabelStyle: AppStyles.lightGray12Regular,
    ),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent),
  );

  static ThemeData darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColor,
    ),
    cardColor: AppColors.bottomNavigationColor,
    scaffoldBackgroundColor: AppColors.darkBlueColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.bottomNavigationColor,
      selectedItemColor: AppColors.yellowColor,
      unselectedItemColor: AppColors.blueColor,
      selectedLabelStyle: AppStyles.primary12Medium.copyWith(color: AppColors.yellowColor),
      unselectedLabelStyle: AppStyles.lightGray12Regular,
    ),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent),
  );
}
