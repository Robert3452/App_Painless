import 'package:flutter/material.dart';
import 'package:painless_app/constants.dart';
import 'package:painless_app/screens/register/components/body.dart';
import 'package:painless_app/size_config.dart';

class Register extends StatelessWidget {
  static String routeName = "/signup";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: Icon(
                  Icons.chevron_left_outlined,
                ),
                onPressed: () {
                  Navigator.pop(context);
                });
          },
        ),
      ),
      body: Body(),
    );
  }
}
