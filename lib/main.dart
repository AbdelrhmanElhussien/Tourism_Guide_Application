import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:tourist_app/core/utils/app_loclization.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/homeScreen.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/homeTap/detailedScreen.dart';
import 'package:tourist_app/features/AppScreens/auth_screen/loginScreen.dart';
import 'package:tourist_app/features/AppScreens/auth_screen/signUp.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [AppLoclization.enLocale, AppLoclization.arLocale],
      path: 'assets/translations',
      saveLocale: true,
      fallbackLocale: AppLoclization.enLocale,
      startLocale: AppLoclization.enLocale,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routes: {
       AppRoutes.loginRouteName:(context)=>Loginscreen(),
        AppRoutes.signUpRouteName:(context)=>SignUpScreen(),
        AppRoutes.HomeRouteName:(context)=>Homescreen(),
        AppRoutes.DetailScreenRouteName:(context)=>DetailScreen(),
      },
      initialRoute: AppRoutes.DetailScreenRouteName,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
    );
  }
}
