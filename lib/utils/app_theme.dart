import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF0083CD); // green
  static const Color secondary = Color(0xff0083cd);

  static const Color lightBackground = Color(0xFFC5C5C5);

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
  static const Color notWhite = Color(0xFFEDF0F2);

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
    scaffoldBackgroundColor: Colors.white,
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
    scaffoldBackgroundColor: Colors.black,
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
