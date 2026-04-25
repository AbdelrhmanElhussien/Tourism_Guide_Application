import 'package:flutter/material.dart';
import 'package:tourist_app/core/utils/app_colors.dart';

import 'app_styles.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkGrayColor
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed
    ),
    scaffoldBackgroundColor: AppColors.blackColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.blackColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.yellowColor),
      titleTextStyle: AppStyles.robotoRegular16Yellow,
    ),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
  );
}
