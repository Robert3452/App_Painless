import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:painless_app/screens/signin/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import 'login_avatar.dart';
import 'package:painless_app/bloc/auth/auth_logic.dart';
import 'package:painless_app/bloc/auth/auth_bloc.dart';
import 'profileButton.dart';

class SignInButton extends StatefulWidget {
  const SignInButton({Key key}) : super(key: key);

  @override
  _SignInButtonState createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    logoutFn();
  }

  void logoutFn() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    print("Token exists: ${storage.containsKey("jwt")}");
    // while (storage.containsKey("jwt")) {
      if (storage.containsKey("jwt")) {
        print(storage.getString("jwt"));
        setState(() {
          isSignedIn = true;
        });
      } else {
        setState(() {
          isSignedIn = false;
        });
      }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return isSignedIn ? ProfileButton(logoutFn) : SignInAvatar();
  }
}

class SignInAvatar extends StatefulWidget {
  const SignInAvatar({Key key}) : super(key: key);

  @override
  _SignInAvatarState createState() => _SignInAvatarState();
}

class _SignInAvatarState extends State<SignInAvatar> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        Navigator.pushNamed(context, Signin.routeName);
      },
      color: kSurfaceColor,
      textColor: Colors.white,
      child: LoginAvatar(),
      shape: CircleBorder(),
    );
  }
}
