import 'package:flutter/material.dart';
import 'package:painless_app/screens/register/register.dart';
import 'package:painless_app/size_config.dart';
import 'package:painless_app/widgets/default_button.dart';
import 'package:painless_app/widgets/social_button.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();

  String email;

  String password;

  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.05,
                  ),
                  Text(
                    "Inicia sesión",
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(34),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.5),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.07),
                  buildEmailFormField(),
                  SizedBox(height: SizeConfig.screenHeight * 0.07),
                  buildPasswordFormField(),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Text(
                          "¿Contraseña olvidada?",
                          style:
                              TextStyle(fontSize: 14, color: kSecondaryColor),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  DefaultButton(
                    press: () {},
                    text: "Iniciar sesión",
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  DefaultButton(
                    press: () {
                      Navigator.pushNamed(context, Register.routeName);
                    },
                    text: "Regístrate",
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "O inicia sesión con:",
                        style: TextStyle(fontSize: 14, color: kSecondaryColor),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  SocialButton(
                    text: "Inicia sesión con Google",
                    press: () {},
                    uriImage: 'assets/icons/signinFacebook.png',
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  SocialButton(
                    text: "Inicia sesión con Facebook",
                    press: () {},
                    uriImage: 'assets/icons/signinGoogle.png',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      style: TextStyle(
        fontSize: 14,
        color: kPrimaryLightColor,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: "Contraseña",
        hintText: "*************",
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length > 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      onSaved: (value) => password = value,
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      style: TextStyle(
        fontSize: 14,
        color: kPrimaryLightColor,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: "Email",
        hintText: "jhondoe@gmail.com",
      ),
    );
  }
}
