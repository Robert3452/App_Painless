import 'package:flutter/material.dart';
import 'package:painless_app/constants.dart';
import '../../../size_config.dart';

class LoginAvatar extends StatelessWidget {
  const LoginAvatar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6),
      child: Icon(

        Icons.person_outline,
        size: getProportionateScreenWidth(35),
        color: kPrimaryLightColor,
      ),
    );
  }
}
