import 'dart:async';

import 'package:client/core/di.dart';
import 'package:client/core/routes.dart';
import 'package:client/core/theme.dart';
import 'package:client/core/logger.dart';
import 'package:client/presentation/providers/side_bar_provider.dart';
import 'package:client/presentation/views/home_screen.dart';
import 'package:client/presentation/views/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

import 'data/repositories/authentiation_repository.dart';
import 'firebase_options.dart';
bool shouldUseFirebaseEmulator = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await runZonedGuarded(() async {
    await EasyLocalization.ensureInitialized();
    await dotenv.load(fileName: '.env');
  }, (Object object, StackTrace stackTrace) {
    logger
      ..e(object)
      ..e(stackTrace);
  });
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if ( shouldUseFirebaseEmulator ) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }
  await DI.init();

  runApp(EasyLocalization(
    child: const MyApp(),
    supportedLocales: const [
      Locale('vi'),
      Locale('en'),
    ],
    path: 'assets/translations',
    fallbackLocale: const Locale('vi'),
    startLocale: const Locale('en'),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: CustomTheme.mainTheme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
        navigatorObservers: [FlutterSmartDialog.observer],
      builder:(context, child) {
          // do your initialization here
          child = EasyLoading.init()(context,child);  // assuming this is returning a widget
          child = FlutterSmartDialog.init()(context,child);
          return child;
        },
      home: StreamBuilder<User?>(
        stream: AuthenticationRepository().authStateChanges,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoginScreen();
          }
          return MultiProvider(
            child: HomeScreen(),
            providers: [
              ChangeNotifierProvider.value(
                  value: sl<SideBarProvider>()),
              // ChangeNotifierProvider.value(value: sl<ProductDetailProvider>()),
            ],
          );
        },
      ),
    );
  }
}
