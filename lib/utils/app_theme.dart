import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Light Theme
  static const Color primary = Color(0xFF0083CD); // green
  static const Color secondary = Color(0xFF96D9FF);

  static const Color backgroundLightGrey = Color(0xFFF6F6F6);
  static const Color backgroundNearlyWhite = Color(0xFFFEFEFE);

  // Dark Theme
  static const Color darkPrimary = Color(0xFF5B86AB);
  static const Color darkSecondary = Color(0xFF83AAC5);

  static const Color backgroundDarkGrey = Color(0xFF383838);



  static const Color errorRed = Color(0xFFFF0000);

  static const Color dividerGrey = Color(0xFFD3D3D3);
  static const Color dividerDarkGrey = Color(0xFF656565);


  static const Color nearlyWhite = Color(0xFFFEFEFE);

  static const Color lightGrey = Color(0xFFBFBFBF);
  
  static const Color chipBackground = Color(0xFFEEF1F3);

  static const TextStyle headline = TextStyle( // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle subHeadline = TextStyle( // h6 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,

    fontSize: 18,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const BoxShadow boxShadow = BoxShadow(
    color: lightGrey,
    offset: Offset(
      0.0,
      1.0,
    ),
    blurRadius: 10.0,
    spreadRadius: 0.5,
  );

  // reference

  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);

  static const Color darkGrey = Color(0xFF7C7C7C);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);

  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'Poppins';

  static const double APPBAR_ELEVATION = 10;

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primarySwatch: Colors.blue,
    accentColor: primary,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.black,
      secondary: Colors.green,
      onSecondary: Colors.white,
      primaryContainer: Colors.orange,
      error: Colors.black,
      onError: Colors.white,
      background: backgroundLightGrey,
      onBackground: Colors.white,
      surface: Colors.pink,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: backgroundLightGrey,
    dividerTheme: DividerThemeData(
      color: AppTheme.dividerGrey,
    ),
    appBarTheme: const AppBarTheme(
      brightness: Brightness.dark,
      elevation: APPBAR_ELEVATION,
      textTheme: TextTheme(
        headline6: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      color: primary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primarySwatch: Colors.blue,
    accentColor: primary,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: darkPrimary,
      onPrimary: Colors.white,
      secondary: Colors.green,
      onSecondary: Colors.white,
      primaryContainer: Colors.pink,
      error: Colors.black,
      onError: Colors.white,
      background: backgroundDarkGrey,
      onBackground: Colors.white,
      surface: Colors.pink,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: backgroundDarkGrey,
    dividerTheme: DividerThemeData(
      color: AppTheme.dividerDarkGrey,
    ),
    appBarTheme: const AppBarTheme(
      elevation: APPBAR_ELEVATION,
      textTheme: TextTheme(
        subtitle1: TextStyle(
          color: primary,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}