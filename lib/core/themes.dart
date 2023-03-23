import 'package:cartzen/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Light Theme

const lightBackground = Color(0xFFFBFBFD);
const lightSubTitleColor = Color(0xFF7C7C7C);
const lightTitleColor = Color(0xFF000000);

ThemeData lightTheme = ThemeData(
  primarySwatch: MaterialColor(themeColor.hashCode, const {
    50: themeColor,
    100: themeColor,
    200: themeColor,
    300: themeColor,
    400: themeColor,
    500: themeColor,
    600: themeColor,
    700: themeColor,
  }),
  scaffoldBackgroundColor: lightBackground,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: lightBackground,
    unselectedIconTheme: IconThemeData(color: lightSubTitleColor),
    selectedIconTheme: IconThemeData(color: themeColor),
  ),
  textTheme: TextTheme(
    titleSmall: GoogleFonts.poppins(
      textStyle: const TextStyle(color: lightTitleColor, fontSize: 14),
    ),
    titleMedium: GoogleFonts.poppins(
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
    titleLarge: GoogleFonts.poppins(
      textStyle: const TextStyle(
          color: lightTitleColor, fontSize: 24, fontWeight: FontWeight.bold),
    ),
    bodySmall: GoogleFonts.poppins(
      textStyle: const TextStyle(color: lightSubTitleColor, fontSize: 14),
    ),
    bodyMedium: GoogleFonts.poppins(
      textStyle: const TextStyle(color: Colors.white, fontSize: 14),
    ),
  ),
);

// Dark Theme

const darkBackground = Color(0xFF191B1C);
const darkSubTitleColor = Color(0xFFDCDCDC);
const darkTitleColor = Color(0xFFFFFFFF);

ThemeData darkTheme = ThemeData(
  primarySwatch: MaterialColor(themeColor.hashCode, const {
    50: themeColor,
    100: themeColor,
    200: themeColor,
    300: themeColor,
    400: themeColor,
    500: themeColor,
    600: themeColor,
    700: themeColor,
    800: themeColor,
    900: themeColor,
  }),
  scaffoldBackgroundColor: darkBackground,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: darkBackground,
    unselectedIconTheme: IconThemeData(color: darkSubTitleColor),
    selectedIconTheme: IconThemeData(color: themeColor),
  ),
  textTheme: TextTheme(
      titleSmall: GoogleFonts.poppins(
        textStyle: const TextStyle(
            color: darkTitleColor, fontSize: 14, fontWeight: FontWeight.bold),
      ),
      titleMedium: GoogleFonts.poppins(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
      titleLarge: GoogleFonts.poppins(
        textStyle: const TextStyle(
            color: darkTitleColor, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      bodySmall: GoogleFonts.poppins(
        textStyle: const TextStyle(color: darkSubTitleColor, fontSize: 14),
      ),
      bodyMedium: GoogleFonts.poppins(
        textStyle: const TextStyle(color: Colors.white, fontSize: 14),
      )),
);
