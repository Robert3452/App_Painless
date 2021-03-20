import 'package:flutter/material.dart';
import 'package:painless_app/constants.dart';
import 'package:painless_app/widgets/default_button.dart';
import 'package:painless_app/size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  String names;
  String email;
  String password;
  String confirm_password;
  bool remember = false;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(5)),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.05,
                    ),
                    Text(
                      "Regístrate",
                      style: TextStyle(
                          fontSize: getProportionateScreenWidth(34),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.5),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.07),
                    buildNamesFormField(),
                    SizedBox(height: SizeConfig.screenHeight * 0.055),
                    buildEmailFormField(),
                    SizedBox(height: SizeConfig.screenHeight * 0.055),
                    builPasswordFormField(),
                    SizedBox(height: SizeConfig.screenHeight * 0.055),
                    builConfirmPasswordFormField(),
                    SizedBox(height: SizeConfig.screenHeight * 0.08),
                    DefaultButton(
                      text: "Regístrate",
                      press: () {},
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildNamesFormField() {
    return TextFormField(
      // onSaved: (newValue),
      style: TextStyle(
        fontSize: 14,
        color: kPrimaryLightColor,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: "Nombres y apellidos",
        hintText: "Jhon Doe",
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
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
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
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

  TextFormField builPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
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
      style: TextStyle(
        fontSize: 14,
        color: kPrimaryLightColor,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: "Contraseña",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: "********************",
      ),
    );
  }

  TextFormField builConfirmPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => confirm_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == confirm_password) {
          removeError(error: kMatchPassError);
        }
        confirm_password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
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
        labelText: "Confirmar contraseña",
        hintText: "********************",
      ),
    );
  }
}

class SuffixIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const SuffixIcon({
    Key key,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: Icon(
        icon,
        color: color,
        size: getProportionateScreenWidth(18),
      ),
      padding: EdgeInsets.fromLTRB(
        0,
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
      ),
    );
  }
}
