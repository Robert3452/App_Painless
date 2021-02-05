import 'package:flutter/material.dart';
import '../../size_config.dart';
import 'components/body.dart';

class Recorder extends StatelessWidget {
  static String routeName = "/recorder";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: Body(),
    );
  }
}