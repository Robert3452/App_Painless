import 'package:flutter/material.dart';
import './rounded_button.dart';
import '../../../constants.dart';

class FloatingButtons extends StatefulWidget {
  final bool isRecording;
  final VoidCallback fnRecording;
  final VoidCallback fnPlaying;

  final bool isPlaying;
  const FloatingButtons({
    Key key,
    this.isRecording,
    this.isPlaying,
    this.fnRecording,
    this.fnPlaying,
  }) : super(key: key);

  @override
  _FloatingButtonsState createState() => _FloatingButtonsState();
}

class _FloatingButtonsState extends State<FloatingButtons> {
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
              iconData: widget.isPlaying ? Icons.stop : Icons.play_arrow,
              onPressed: null,
              mini: true,
              bgColor: kSurfaceColor,
            ),
            RoundedButton(
              bgColor: kPrimaryColor,
              iconData: widget.isRecording ? Icons.stop : Icons.brightness_1,
              onPressed: widget.fnRecording,
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
