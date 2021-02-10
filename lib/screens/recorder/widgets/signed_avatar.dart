import 'package:flutter/material.dart';
import '../../../size_config.dart';

class SignedAvatar extends StatelessWidget {
  final String image;

  const SignedAvatar({
    Key key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: getProportionateScreenWidth(22),
      backgroundImage: NetworkImage(
        image,
      ),
    );
  }
}
