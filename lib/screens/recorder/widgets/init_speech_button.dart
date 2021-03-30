import 'package:flutter/material.dart';
import 'package:painless_app/screens/recorder/widgets/rounded_button.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../constants.dart';

class InitSpeechButton extends StatelessWidget {
  final VoidCallback stopListening;
  final VoidCallback startListening;

  const InitSpeechButton({
    Key key,
    @required bool hasSpeech,
    @required this.speech,
    @required this.startListening,
    @required this.stopListening,
  })  : _hasSpeech = hasSpeech,
        super(key: key);

  final bool _hasSpeech;
  final SpeechToText speech;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RoundedButton(
            color: Color(0xFFfffFFF),
            mini: false,
            iconData:
                !_hasSpeech || speech.isListening ? Icons.stop : Icons.mic,
            bgColor: kSurfaceColor,
            onPressed: !_hasSpeech || speech.isListening
                ? stopListening
                : startListening,
          )
        ],
      ),
    );
  }
}
