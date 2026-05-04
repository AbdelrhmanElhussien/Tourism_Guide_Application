import 'package:flutter/material.dart';
import 'package:tourist_app/core/utils/app_colors.dart';

import 'app_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    dialogTheme: DialogThemeData(),
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
}

