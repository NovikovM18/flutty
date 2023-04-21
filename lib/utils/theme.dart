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

    scaffoldBackgroundColor: darkBackgroundColor,
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

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,

    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(135, 245, 220, 220),
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: mainFont,
        fontSize: MediumTextSize,
        fontWeight: FontWeight.w500,
        color: Color.fromARGB(255, 0, 255, 217),
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
        color: Color.fromARGB(255, 0, 255, 255),
      ),
      bodyMedium: TextStyle(
        fontFamily: mainFont,
        fontSize: BodyTextSize,
        fontWeight: FontWeight.w500,
        color: Color.fromARGB(255, 255, 234, 0),
      ),
      bodySmall: TextStyle(
        fontFamily: mainFont,
        fontSize: SmallTextSize,
        fontWeight: FontWeight.w400,
        color: Color.fromARGB(255, 255, 47, 0),
      ),
    ),

    iconTheme: const IconThemeData(
      size: 25.0,
      color: Color.fromARGB(255, 255, 68, 0),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(126, 60, 215, 12),
      foregroundColor: Color.fromARGB(255, 255, 234, 0),
      iconSize: 22
    ),

    buttonTheme: const ButtonThemeData(
      // height: 80,
      buttonColor: Color.fromARGB(255, 173, 224, 19),
      textTheme: ButtonTextTheme.primary,
    ),

    scaffoldBackgroundColor: lightBackgroundColor,
    dialogBackgroundColor: Color.fromARGB(255, 252, 250, 250),

    cardTheme: const CardTheme(
      color: customColors.purpleBG,
      // shadowColor: Colors.red
    ),

    listTileTheme: const ListTileThemeData(
      tileColor: customColors.purpleBG,
    ),

    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(199, 247, 241, 241),
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