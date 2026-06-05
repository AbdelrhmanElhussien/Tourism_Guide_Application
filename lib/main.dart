import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';

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
      supportedLocales: [
        AppLoclization.enLocale,
        AppLoclization.arLocale,
        AppLoclization.deLocale,
        AppLoclization.frLocale,
        AppLoclization.itLocale,
        AppLoclization.esLocale,
        AppLoclization.ruLocale,
        AppLoclization.zhLocale,
      ],
      path: 'assets/translations',
      saveLocale: true,
      fallbackLocale: AppLoclization.enLocale,
      startLocale: AppLoclization.enLocale,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Themeprovider())
        ],
          child: const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // todo: This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routes: {
       AppRoutes.loginRouteName:(context)=>LoginScreen(),
        AppRoutes.signUpRouteName:(context)=>SignUpScreen(),
        AppRoutes.HomeRouteName:(context)=>Homescreen(),
        AppRoutes.DetailScreenRouteName:(context)=>DetailScreen(),
      },
      initialRoute: AppRoutes.loginRouteName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.apptheme,
    );
  }
}
