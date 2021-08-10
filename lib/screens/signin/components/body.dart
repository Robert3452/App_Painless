import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:painless_app/screens/recorder/recorder.dart';
import 'package:painless_app/screens/register/register.dart';
import 'package:painless_app/size_config.dart';
import 'package:painless_app/widgets/default_button.dart';
import 'package:painless_app/widgets/social_button.dart';
import 'package:painless_app/bloc/auth/auth_bloc.dart';
import 'package:painless_app/bloc/auth/auth_logic.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final _authBloc = AuthBloc(authLogic: JWTAuth());
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

  void toggleAdvice({bool loggedIn}) {
    String message = !loggedIn
        ? "Email o contraseña no coinciden"
        : "Inicio de sesión exitoso";
    String title = !loggedIn
        ? "Inicio de sesión no válido"
        : "Iniciaste sesión correctamente";

    List<Widget> signedInActions = [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Recorder.routeName);
        },
        child: Text('Ok'),
      ),
    ];
    List<Widget> errorActions = [
      TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Ok'))
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: loggedIn ? signedInActions : errorActions,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    email = "";
    password = "";
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
            child: BlocProvider(
              create: (context) => _authBloc,
              child: BlocListener(
                bloc: _authBloc,
                listener: (context, state) {
                  if (state is LoggedInJWT) {
                    toggleAdvice(loggedIn: state.response['message']);
                  }
                },
                child: BlocBuilder<AuthBloc, AuthState>(
                  bloc: _authBloc,
                  builder: (context, state) => Form(
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
                                style: TextStyle(
                                    fontSize: 14, color: kSecondaryColor),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.03),
                        DefaultButton(
                          press: _doLogin,
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
                              style: TextStyle(
                                  fontSize: 14, color: kSecondaryColor),
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                        SocialButton(
                          text: "Inicia sesión con Google",
                          press: () {},
                          uriImage: 'assets/icons/signinGoogle.png',
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.04),
                        SocialButton(
                          text: "Inicia sesión con Facebook",
                          press: () {},
                          uriImage: 'assets/icons/signinFacebook.png',
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _doLogin() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _authBloc.add(SignInJWT(email, password));
    }
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
      onSaved: (value) {
        password = value;
      },
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) {
        email = newValue;
      },
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
