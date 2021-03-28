import 'package:flutter/material.dart';

import '../../../constants.dart';

class SearchText extends StatelessWidget {
  const SearchText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryLightColor,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: "Buscar",
            prefixIcon: Icon(
              Icons.search,
              color: Color.fromARGB(80, 255, 255, 255),
            ),
          ),
        ),
      ],
    );
  }
}
