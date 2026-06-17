import 'package:flutter/material.dart';
import 'package:tourist_app/core/utils/cache_helper.dart';

class Themeprovider extends ChangeNotifier {
  ThemeMode apptheme = ThemeMode.light;

  Themeprovider() {
    try {
      final isDark = CacheHelper.getData(key: 'isDarkMode') as bool?;
      if (isDark != null) {
        apptheme = isDark ? ThemeMode.dark : ThemeMode.light;
      }
    } catch (_) {}
  }

  void changeTheme(ThemeMode newTheme) {
    if (apptheme == newTheme) {
      return;
    }
    apptheme = newTheme;
    try {
      CacheHelper.saveData(key: 'isDarkMode', value: apptheme == ThemeMode.dark);
    } catch (_) {}
    notifyListeners();
  }
}
