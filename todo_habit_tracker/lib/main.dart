import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animations/animations.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Habit Tracker',
      theme: FlexThemeData.light(
        scheme: FlexScheme.custom,
        primary: const Color(0xFFCADBFC), // Light blue from palette
        secondary: const Color(0xFFEBBCFC), // Medium purple from palette
        tertiary: const Color(0xFFF9EAFE), // Light lavender from palette
        surface: Colors.white, // Force white surface
        background: Colors.white, // Force white background
        scaffoldBackground: Colors.white, // Force white scaffold background
        error: const Color(0xFFFF0061), // Bright pink from palette
        fontFamily: GoogleFonts.preahvihear().fontFamily,
        textTheme: GoogleFonts.preahvihearTextTheme(),
        useMaterial3: true,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ).copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeThroughPageTransitionsBuilder(),
          },
        ),
      ),
      themeMode: ThemeMode.light,
      home: const HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
