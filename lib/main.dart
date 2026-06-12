import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/BlocObserver.dart';
import 'package:tourist_app/core/utils/app_loclization.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/homeScreen.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/homeTap/detailedScreen.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/profileTap/provider_dashboard.dart';
import 'package:tourist_app/features/AppScreens/auth_screen/Login/loginScreen.dart';
import 'package:tourist_app/features/AppScreens/auth_screen/signUp/signUp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [AppLoclization.enLocale, AppLoclization.arLocale],
      path: 'assets/translations',
      saveLocale: true,
      fallbackLocale: AppLoclization.enLocale,
      startLocale: AppLoclization.enLocale,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Themeprovider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // todo: This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    return ScreenUtilInit(
      designSize: Size(
        375,
        812,
      ), //  (iPhone 13 مثلاً)
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          scrollBehavior: const _AppScrollBehavior(),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routes: {
            AppRoutes.loginRouteName: (context) => LoginScreen(),
            AppRoutes.signUpRouteName: (context) => SignUpScreen(),
            AppRoutes.HomeRouteName: (context) => Homescreen(),
            AppRoutes.DetailScreenRouteName: (context) => DetailScreen(),
            AppRoutes.serviceProviderRouteName: (context) => const ServiceProviderScreen(),
          },
          initialRoute: AppRoutes.HomeRouteName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,

          themeMode: themeProvider.apptheme,
        );
      },
    );
  }
}

class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return GlowingOverscrollIndicator(
      axisDirection: details.direction,
      color: const Color(0x33232B55),
      child: child,
    );
  }
}
