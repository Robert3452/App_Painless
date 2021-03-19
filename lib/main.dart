import 'package:flutter/material.dart';
import 'package:painless_app/constants.dart';
import 'package:painless_app/routes.dart';
import 'package:painless_app/screens/recorder/recorder.dart';
import 'package:painless_app/theme.dart';

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
      theme: theme(),
      initialRoute: Recorder.routeName,
      routes: routes,
    );
  }
}
