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
import 'package:tourist_app/features/home/screens/home_screen.dart';
import 'package:tourist_app/features/home/screens/detailed_screen.dart';
import 'package:tourist_app/features/profile/service_provider/screens/provider_dashboard_screen.dart';
import 'package:tourist_app/features/profile/service_provider/screens/my_services_screen.dart';
import 'package:tourist_app/features/profile/service_provider/screens/bookings_screen.dart';
import 'package:tourist_app/features/profile/service_provider/screens/add_service_screen.dart';
import 'package:tourist_app/features/profile/screens/my_trips_screen.dart';
import 'package:tourist_app/features/profile/screens/saved_places_screen.dart';
import 'package:tourist_app/features/auth/login/screens/login_screen.dart';
import 'package:tourist_app/features/auth/signup/screens/signup_screen.dart';
import 'package:tourist_app/features/map/provider/map_provider.dart';
import 'package:tourist_app/features/profile/service_provider/screens/earnings_screen.dart';
import 'package:tourist_app/features/guide/provider/guide_provider.dart';
import 'package:tourist_app/features/explore/provider/hotel_provider.dart';
import 'package:tourist_app/features/explore/provider/transport_provider.dart';
import 'package:tourist_app/features/explore/provider/program_provider.dart';
import 'package:tourist_app/features/booking/provider/booking_provider.dart';
import 'package:tourist_app/features/home/provider/place_provider.dart';
import 'package:tourist_app/core/utils/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await EasyLocalization.ensureInitialized();
  await CacheHelper.init();

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
          ChangeNotifierProvider(create: (context) => Themeprovider()),
          ChangeNotifierProvider(create: (context) => MapProvider()),
          ChangeNotifierProvider(create: (context) => GuideProvider()),
          ChangeNotifierProvider(create: (context) => HotelProvider()),
          ChangeNotifierProvider(create: (context) => TransportProvider()),
          ChangeNotifierProvider(create: (context) => ProgramProvider()),
          ChangeNotifierProvider(create: (context) => BookingProvider()),
          ChangeNotifierProvider(create: (context) => PlaceProvider()),
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
      designSize: const Size(375, 812), //  (iPhone 13 مثلاً)
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
            AppRoutes.DetailScreenRouteName: (context) => const DetailScreen(),
            AppRoutes.serviceProviderRouteName: (context) =>
                const ServiceProviderScreen(),
            AppRoutes.myServicesRouteName: (context) =>
                const MyServicesScreen(),
            AppRoutes.bookingsRouteName: (context) => const BookingsScreen(),
            AppRoutes.myTripsRouteName: (context) => const MyTripsScreen(),
            AppRoutes.savedPlacesRouteName: (context) =>
                const SavedPlacesScreen(),
            AppRoutes.addServiceRouteName: (context) =>
                const AddServiceScreen(),
            AppRoutes.earningsRouteName: (context) => const EarningsScreen(),
          },
          initialRoute: AppRoutes.loginRouteName,
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
