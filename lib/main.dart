import 'dart:io';

import 'package:chatgpt_course/providers/models_provider.dart';
import 'package:chatgpt_course/screens/Splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'constants/api_consts.dart';
import 'constants/constants.dart';
import 'providers/chats_provider.dart';

Future<void> main() async {
  await _initApp();
  runApp(const MyApp());
}

class OwnHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future _initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = OwnHttpOverrides();
  initi();
  // Initialize without device test ids.
  MobileAds.instance.initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Chat AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.grey[850],
            textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme),
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.grey[850]),
            canvasColor: Colors.white,
            cardColor: Colors.white,
            scaffoldBackgroundColor: scaffoldBackgroundColor,
            appBarTheme: AppBarTheme(
              color: cardColor,
            )),
        home: const Splash(),
      ),
    );
  }
}
