import 'package:flutter/material.dart';

final RegExp emailValidatorRegExp =
    RegExp(r"""^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$""");

const String kEmailNullError = "Por favor ingrese un email";
const String kInvalidEmailError = "Por favor ingrese un email valido";    
const String kPassNullError = "Por favor ingrese una contraseña";
const String kShortPassError = "La contraseña es muy corta";
const String kMatchPassError = "Las contraseñas no coinciden";
const String kNamelNullError = "Ingrese un nombre";

const primaryColor = 0xFFE62B3E;
const kBackgroundColor = Color(0xff121212);
const kSurfaceColor = Color(0xff2E2929);
const kBtnRed = Color(0xffE62B3E);
const kSurfaceLightColor = Color(0xffEBEBEB);
const kPrimaryColor = Color(primaryColor);
const kPrimaryLightColor = Color(0xFFFAF8F8);
const kSecondaryColor = Color(0xFF979797);

const kAnimationDuration = Duration(milliseconds: 200);
