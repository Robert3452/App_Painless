import 'package:flutter/material.dart';
import 'package:painless_app/screens/record_files/widgets/search_text.dart';
import 'package:painless_app/screens/record_files/widgets/listview_files.dart';
import 'package:painless_app/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: Stack(
            children: [
              ListViewFiles(),
              SearchText(),
            ],
          ),
        ),
      ),
    );
  }
}
