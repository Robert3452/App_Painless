import 'package:flutter/material.dart';
import 'package:painless_app/constants.dart';

Widget createToast({String text}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Color.fromRGBO(255, 255, 255, 0.2),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check,
          color: kPrimaryLightColor,
        ),
        SizedBox(
          width: 12.0,
        ),
        Text(text),
      ],
    ),
  );
}

