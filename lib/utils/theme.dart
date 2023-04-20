import 'package:flutter/material.dart';
import 'package:flutty/utils/vars.dart';

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,

    appBarTheme: const AppBarTheme(
      backgroundColor: customColors.greyBG,
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
        fontWeight: FontWeight.w700,
        color: customColors.green,
      ),
      bodyMedium: TextStyle(
        fontFamily: mainFont,
        fontSize: BodyTextSize,
        fontWeight: FontWeight.w500,
        color: Color.fromARGB(255, 217, 255, 0),
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
      backgroundColor: customColors.purpleBG,
      foregroundColor: customColors.pink,
      iconSize: 22
    ),

    buttonTheme: const ButtonThemeData(
      // height: 80,
      buttonColor: Colors.deepPurple,
      textTheme: ButtonTextTheme.primary,
    ),

    scaffoldBackgroundColor: backgroundColor,
    dialogBackgroundColor: customColors.greyBG,

    cardTheme: const CardTheme(
      color: customColors.purpleBG,
      // shadowColor: Colors.red
    ),

    listTileTheme: const ListTileThemeData(
      tileColor: customColors.purpleBG,
    ),

    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: customColors.greyBG,
      selectedItemColor: Colors.white,
      unselectedItemColor: Color.fromARGB(255, 99, 99, 99),
    ),

    dialogTheme: const DialogTheme(
      titleTextStyle: TextStyle(
        fontFamily: mainFont,
        fontSize: MediumTextSize,
        fontWeight: FontWeight.w500,
        color: customColors.green,
      ),
    )

    
  );
}