import 'package:flutter/material.dart';

import '../../../constants.dart';

class ScreenRecorder extends StatelessWidget {
  final String timer;
  const ScreenRecorder({
    Key key,
    @required bool isRecording,
    this.timer,
  })  : _isRecording = isRecording,
        super(key: key);

  final bool _isRecording;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              timer,
              style: TextStyle(
                color: kPrimaryLightColor,
                fontSize: 50,
              ),
            ),
          ),
          Text(
            !_isRecording ? "Comience a grabar" : "Grabando",
            style: TextStyle(
              color: kPrimaryLightColor,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
