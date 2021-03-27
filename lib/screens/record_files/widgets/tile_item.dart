import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class TileItem extends StatelessWidget {
  final String nameFile;
  final String hour;
  final String date;
  final Function press;
  final int id;

  const TileItem({
    Key key,
    this.nameFile,
    this.hour,
    this.date,
    this.press,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        nameFile,
        style: TextStyle(color: kPrimaryLightColor),
      ),
      subtitle: Row(
        children: [
          //Hour text
          SizedBox(
            width: getProportionateScreenWidth(60),
            child: Text(
              hour,
              style: TextStyle(color: kPrimaryLightColor),
            ),
          ),
          //Date Text
          Expanded(
            child: Text(
              date,
              style: TextStyle(color: kPrimaryLightColor),
            ),
          ),
        ],
      ),
      leading: FloatingActionButton(
        heroTag: id,
        onPressed: press,
        backgroundColor: Color.fromARGB(50, 255, 255, 255),
        mini: true,
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
