import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_loclization.dart';
import 'package:tourist_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    const channel = MethodChannel('plugins.flutter.io/shared_preferences');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'getAll') {
            return <String, Object>{};
          }
          return null;
        });
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: [AppLoclization.enLocale, AppLoclization.arLocale],
        path: 'assets/translations',
        fallbackLocale: AppLoclization.enLocale,
        startLocale: AppLoclization.enLocale,
        child: ChangeNotifierProvider(
          create: (context) => Themeprovider(),
          child: const MyApp(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Explore'), findsWidgets);
  });
}
