import 'package:flutter/material.dart';
import 'package:flutty/utils/vars.dart';

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    dialogBackgroundColor: customColors.grayBG,
    primaryColor: primaryColor,

    appBarTheme: const AppBarTheme(
      backgroundColor: customColors.grayBG,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: mainFont,
        fontSize: MediumTextSize,
        fontWeight: FontWeight.w500,
        color: customColors.green,
      ),
      iconTheme: IconThemeData(
        color: customColors.pink
      )
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontFamily: mainFont,
        fontSize: LargeTextSize,
        fontWeight: FontWeight.w600,
        color: customColors.green,
      ),
      bodyMedium: TextStyle(
        fontFamily: mainFont,
        fontSize: BodyTextSize,
        fontWeight: FontWeight.w400,
        color: Colors.amber,
      ),
      bodySmall: TextStyle(
        fontFamily: mainFont,
        fontSize: SmallTextSize,
        fontWeight: FontWeight.w400,
        color: customColors.pink,
      ),
      
    ),

    iconTheme: const IconThemeData(
      size: 25.0,
      color: customColors.pink,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.red,
      foregroundColor: Colors.purple,
    ),

    buttonTheme: const ButtonThemeData(
      // height: 80,
      buttonColor: Colors.deepPurple,
      textTheme: ButtonTextTheme.accent,
    ),

    cardTheme: const CardTheme(
      color: Color.fromARGB(99, 155, 39, 176),
      // shadowColor: Colors.red
    ),

    scaffoldBackgroundColor: backgroundColor,
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: customColors.grayBG,
      selectedItemColor: Colors.white,
      unselectedItemColor: Color.fromARGB(255, 99, 99, 99),

    )
  );
}