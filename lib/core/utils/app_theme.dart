import 'package:flutter/material.dart';
import 'package:tourist_app/core/utils/app_colors.dart';

import 'app_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
    ),
    cardColor: AppColors.whiteColor,
    scaffoldBackgroundColor: AppColors.whiteColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.whiteColor,
      selectedItemColor: AppColors.yellowColor,
      unselectedItemColor: AppColors.lightGrayColor,
      selectedLabelStyle:AppStyles.primary12Medium.copyWith(color: AppColors.yellowColor),
      unselectedLabelStyle:AppStyles.lightGray12Regular,
    ),

    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
  );
  static ThemeData darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
    ),
    cardColor: AppColors.cardColor,
    scaffoldBackgroundColor: AppColors.darkBlueColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.bottomNavigationColor,
      selectedItemColor: AppColors.yellowColor,
      unselectedItemColor: AppColors.blueColor,
      selectedLabelStyle:AppStyles.primary12Medium.copyWith(color: AppColors.yellowColor),
      unselectedLabelStyle:AppStyles.lightGray12Regular,
    ),

    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
  );
}

