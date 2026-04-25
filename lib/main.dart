import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:tourist_app/core/utils/app_loclization.dart';
import 'package:tourist_app/features/auth_screen/loginScreen.dart';
import 'package:tourist_app/features/auth_screen/signUp.dart';

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
        Loginscreen.routName: (context) => Loginscreen(),
        SignUpScreen.routName: (context) => SignUpScreen(),
      },
      initialRoute: Loginscreen.routName,
      home: Loginscreen(),
    );
  }
}
