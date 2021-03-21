import 'package:flutter/material.dart';
import 'package:painless_app/constants.dart';
import '../../size_config.dart';
import './components/body.dart';
class Signin extends StatelessWidget {
  static String routeName = "/signin";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        leading: Builder(
          builder: (context) {
            return IconButton(
              iconSize: getProportionateScreenWidth(40),
              icon: Icon(Icons.chevron_left_outlined),
              onPressed: () => Navigator.pop(context),
            );
          },
        ),
      ),
      body: Body(),
    );
  }
}
