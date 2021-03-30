import 'package:flutter/material.dart';
import 'package:painless_app/screens/register/register.dart';
import 'package:painless_app/screens/signin/signin.dart';
import 'package:painless_app/size_config.dart';
import '../../../constants.dart';
import 'login_avatar.dart';

class AppbarRecorder extends StatelessWidget {
  final bool showDashboard;
  const AppbarRecorder({
    Key key, this.showDashboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                !showDashboard ? '' : 'Dashboard',
                style: TextStyle(
                    fontSize: getProportionateScreenWidth(30),
                    fontWeight: FontWeight.bold),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, Signin.routeName);
                },
                color: kSurfaceColor,
                textColor: Colors.white,
                child:
                    // SignedAvatar(
                    //   image: "https://static.toiimg.com/photo/76729750.cms",
                    // ),
                    LoginAvatar(),
                shape: CircleBorder(),
              )
            ],
          ),
        ));
  }
}
