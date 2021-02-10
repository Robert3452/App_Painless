import 'package:flutter/material.dart';

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
