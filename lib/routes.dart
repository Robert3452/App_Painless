import 'package:flutter/widgets.dart';
import 'screens/recorder/recorder.dart';
import 'screens/register/register.dart';

final Map<String, WidgetBuilder> routes = {
  Recorder.routeName : (context) => Recorder(),
  Register.routeName : (context) => Register(),

};