
import 'package:flutter/material.dart';
import './rounded_button.dart';
import '../../../constants.dart';

class FloatingButtons extends StatelessWidget {
  const FloatingButtons({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RoundedButton(
              color: Color(0xFFFFFFFFF),
              iconData: Icons.dashboard,
              onPressed: null,
              mini: true,
              bgColor: kSurfaceColor,
            ),
            RoundedButton(
              bgColor: kPrimaryColor,
              iconData: Icons.brightness_1,
              onPressed: null,
              mini: false,
              color: Color(0xFFFFFFFFF),
            ),
            RoundedButton(
              bgColor: kSurfaceColor,
              iconData: Icons.dehaze,
              onPressed: () {},
              mini: true,
              color: Color(0xFFFFFFFFF),
            ),
          ],
        ));
  }
}
