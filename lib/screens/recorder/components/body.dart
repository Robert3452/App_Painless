import 'package:flutter/material.dart';
import 'package:painless_app/constants.dart';
import 'package:painless_app/screens/recorder/widgets/login_avatar.dart';
import 'package:painless_app/screens/recorder/widgets/rounded_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../size_config.dart';
import '../../../bloc/post_logic.dart';
import '../../../bloc/post_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    // print("Received error status: $error, listening: ${speech.isListening}");
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
                  print(_isRecording);
                  _isRecording = state.response["agressive"];
                  print(_isRecording);

                }

                return Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                            !_isRecording ? "Comience a grabar" : "Grabando",
                            style: TextStyle(
                              color: kPrimaryLightColor,
                              fontSize: 20,
                            ),
                          ),
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
                              iconData: !_hasSpeech || speech.isListening
                                  ? Icons.stop
                                  : Icons.mic,
                              bgColor: kSurfaceColor,
                              onPressed: !_hasSpeech || speech.isListening
                                  ? stopListening
                                  : startListening,
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
                              onPressed: null,
                              mini: true,
                              bgColor: kSurfaceColor,
                            ),
                            RoundedButton(
                              bgColor: kPrimaryColor,
                              iconData: Icons.brightness_1,
                              onPressed: null,
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
                );
              },
            )),
      ),
    );
  }

  void resultListener(SpeechRecognitionResult result) {
    // ++resultListened;
    String sentence = result.recognizedWords;

    print('Result listened $sentence');
    // context.read<PostBloc>().add(DoPostEvent(sentence));
    // BlocProvider.of<PostBloc>(context)
    _postBloc.add(DoPostEvent(result.recognizedWords));
    // setState(() {
    //   lastWords = '${result.recognizedWords} - ${result.finalResult}';
    //   print('$lastWords');
    // });
  }
}
