import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:painless_app/constants.dart';
import '../size_config.dart';

class SocialButton extends StatelessWidget {
  final Function press;
  final String text;
  final String uriImage;

  const SocialButton({Key key, this.press, this.text, this.uriImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(48),
      child: FlatButton(
        // shape:
        //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
        color: kPrimaryLightColor,
        onPressed: press,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: getProportionateScreenWidth(30),
              child: Image(
                image: AssetImage(uriImage),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    color: kSecondaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
