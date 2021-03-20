import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: kBackgroundColor,
    inputDecorationTheme: inputDecorationTheme(),
    textTheme: textTheme(),
    appBarTheme: appBarTheme(),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: kPrimaryLightColor,
    // backgroundColor: kBackgroundColor,
    elevation: 0,
    brightness: Brightness.dark,
    iconTheme: IconThemeData(color: kPrimaryLightColor),
    textTheme: TextTheme(
      headline6: TextStyle(color: kPrimaryLightColor, fontSize: 18),
    ),
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
      width: 0,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(22.0),
    ),
  );

  return InputDecorationTheme(
    fillColor: Color.fromARGB(30, 255, 255, 255),
    hintStyle: TextStyle(color: Color.fromARGB(80, 255, 255, 255)),
    labelStyle: TextStyle(color: kPrimaryLightColor, height: 0.6, fontSize: 20),
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    filled: true,
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

TextTheme textTheme() {
  return TextTheme(
    bodyText1: TextStyle(color: kPrimaryLightColor),
    bodyText2: TextStyle(color: kPrimaryLightColor),
  );
}
