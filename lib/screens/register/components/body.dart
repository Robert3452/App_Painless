import 'package:flutter/material.dart';
import 'package:painless_app/constants.dart';
import 'package:painless_app/screens/register/components/default_button.dart';
import 'package:painless_app/size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
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
                      height: SizeConfig.screenHeight * 0.04,
                    ),
                    Text(
                      "Regístrate",
                      style: TextStyle(
                          fontSize: getProportionateScreenWidth(28),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.5),
                    ),

                    SizedBox(height: SizeConfig.screenHeight * 0.055),
                    buildNamesFormField(),

                    SizedBox(height: SizeConfig.screenHeight * 0.055),
                    buildEmailFormField(),

                    SizedBox(height: SizeConfig.screenHeight * 0.055),
                    builPasswordFormField(),

                    SizedBox(height: SizeConfig.screenHeight * 0.055),
                    builConfirmPasswordFormField(),

                    SizedBox(height: SizeConfig.screenHeight * 0.055),
                    DefaultButton(
                      text: "Regístrate",
                      press: () {},
                    )
                    //form,
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
      // onSaved: (newValue),
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
      // onSaved: (newValue),
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
      // onSaved: (newValue),
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
