import 'package:flutter/material.dart';
import 'package:painless_app/constants.dart';
import 'package:painless_app/screens/recorder/widgets/appbar_recorder.dart';
import 'package:painless_app/screens/recorder/widgets/init_speech_button.dart';
import 'package:painless_app/screens/recorder/widgets/screen_recorder.dart';
import '../widgets/floating_buttons.dart';
import '../widgets/login_avatar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../size_config.dart';
import '../../../bloc/post_logic.dart';
import '../../../bloc/post_bloc.dart';

import 'dart:async';
import 'dart:math';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  int resultListened = 0;
  bool _isRecording = false;
  PostBloc _postBloc = PostBloc(logic: SimpleHttpLogic());
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    var hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener, debugLogging: true);

    if (hasSpeech) {
      _localeNames = await speech.locales();
      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    String sentence = result.recognizedWords;
    print('Result listened $sentence');
    _postBloc.add(DoPostEvent(sentence));
  }

  void startListening() {
    lastWords = '';
    lastError = '';
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 5),
        pauseFor: Duration(seconds: 5),
        partialResults: false,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = '$status';
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(logic: SimpleHttpLogic()),
      child: SafeArea(
        child: SizedBox(
            width: double.infinity,
            child: BlocBuilder<PostBloc, PostState>(
              cubit: _postBloc,
              builder: (context, state) {
                if (state is PostedBlocState) {
                  _isRecording = state.response["agressive"];
                }

                return Column(
                  children: [
                    AppbarRecorder(),
                    ScreenRecorder(isRecording: _isRecording),
                    InitSpeechButton(
                      hasSpeech: _hasSpeech,
                      speech: speech,
                      startListening: startListening,
                      stopListening: cancelListening,
                    ),
                    FloatingButtons()
                  ],
                );
              },
            )),
      ),
    );
  }
}
