import 'package:flutter/material.dart';
import 'package:painless_app/constants.dart';
import 'package:painless_app/size_config.dart';
import './components/body.dart';

class RecordFiles extends StatelessWidget {
  static String routeName = "/files";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kBackgroundColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                iconSize: getProportionateScreenWidth(40),
                icon: Icon(
                  Icons.chevron_left_outlined,
                ),
                onPressed: () {
                  Navigator.pop(context);
                });
          },
        ),
        title: Text(
          "Grabaciones",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
          ),
        ),
      ),
      body: Body(),
    );
  }
}
