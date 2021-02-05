import 'package:flutter/material.dart';
import 'package:painless_app/constants.dart';
import '../../../size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // CircleAvatar(
                    //   backgroundImage: AssetImage('assets/icons/profile.png'),
                    //   radius: 30,
                    // )
                    MaterialButton(
                      onPressed: () {},
                      color: kSurfaceColor,
                      textColor: Colors.white,
                      child:
                          // SignedAvatar(
                          //   image: "https://static.toiimg.com/photo/76729750.cms",
                          // ),
                          LoginAvatar(),
                      shape: CircleBorder(),
                    )
                  ],
                )),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "00:00:00",
                      style: TextStyle(
                        color: kPrimaryLightColor,
                        fontSize: 50,
                      ),
                    ),
                  ),
                  Text(
                    "Comience a grabar",
                    style: TextStyle(
                      color: kPrimaryLightColor,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RoundedButton(
                      color: Color(0xFFfffFFF),
                      mini: false,
                      iconData: Icons.mic,
                      bgColor: kSurfaceColor,
                      onPressed: () {},
                    )
                  ],
                )),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RoundedButton(
                      color: Color(0xFFFFFFFFF),
                      iconData: Icons.dashboard,
                      onPressed: () {},
                      mini: true,
                      bgColor: kSurfaceColor,
                    ),
                    RoundedButton(
                      bgColor: kPrimaryColor,
                      iconData: Icons.brightness_1,
                      onPressed: () {},
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
                ))
          ],
        ),
      ),
    );
  }
}

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

class LoginAvatar extends StatelessWidget {
  const LoginAvatar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6),
      child: Icon(
        Icons.person_outline,
        size: getProportionateScreenWidth(35),
      ),
    );
  }
}

class RoundedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color bgColor;
  final Color color;
  final IconData iconData;
  final bool mini;
  const RoundedButton({
    Key key,
    @required this.onPressed,
    @required this.bgColor,
    @required this.color,
    @required this.iconData,
    @required this.mini,
  }) : super(key: key);

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: widget.onPressed,
      heroTag: null,
      mini: widget.mini,
      child: Icon(
        widget.iconData,
        color: widget.color,
      ),
      elevation: 0,
      backgroundColor: widget.bgColor,
    );
  }
}
