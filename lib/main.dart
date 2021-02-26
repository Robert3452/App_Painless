import 'package:flutter/material.dart';
import 'package:painless_app/constants.dart';
import 'package:painless_app/screens/recorder/recorder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Painless App',
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: kPrimaryColor),
          bodyText2: TextStyle(color: kPrimaryColor),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Recorder(),
    );
  }
}
