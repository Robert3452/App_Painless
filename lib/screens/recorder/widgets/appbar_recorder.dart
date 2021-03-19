import 'package:flutter/material.dart';
import 'package:painless_app/screens/register/register.dart';
import '../../../constants.dart';
import 'login_avatar.dart';

class AppbarRecorder extends StatelessWidget {
  const AppbarRecorder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, Register.routeName);
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
        ));
  }
}

