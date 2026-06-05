import 'package:flutter/material.dart';

class Themeprovider extends ChangeNotifier {

  ThemeMode apptheme = ThemeMode.light;

  void changeTheme (ThemeMode newTheme) {
    if(apptheme == newTheme){
      return;
    }
    apptheme = newTheme;
  }
}