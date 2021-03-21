import 'package:flutter/widgets.dart';
import 'package:painless_app/screens/signin/signin.dart';
import 'screens/recorder/recorder.dart';
import 'screens/register/register.dart';
import 'package:painless_app/screens/record_files/record_files.dart';

final Map<String, WidgetBuilder> routes = {
  Recorder.routeName: (context) => Recorder(),
  Register.routeName: (context) => Register(),
  Signin.routeName: (context) => Signin(),
  RecordFiles.routeName: (context) => RecordFiles()
};
