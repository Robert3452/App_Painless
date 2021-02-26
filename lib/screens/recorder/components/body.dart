import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:painless_app/screens/recorder/widgets/appbar_recorder.dart';
import 'package:painless_app/screens/recorder/widgets/init_speech_button.dart';
import 'package:painless_app/screens/recorder/widgets/rounded_button.dart';
import 'package:painless_app/screens/recorder/widgets/screen_recorder.dart';
import 'package:painless_app/utils/app_utils.dart';
import '../../../constants.dart';
import '../widgets/floating_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
// import '../../../size_config.dart';
import '../../../bloc/post_logic.dart';
import '../../../bloc/post_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:math';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

typedef _Fn = void Function();

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

  FlutterSoundPlayer _myPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder _myRecorder = FlutterSoundRecorder();
  bool _myPlayerIsInited = false;
  bool _myRecorderIsInited = false;
  bool _myPlaybackReady = false;
  String _mPath = "flutter_sound_example.mp3";

  @override
  void initState() {
    initSpeechState();
    super.initState();
  }

  Future<void> initSpeechState() async {
    var status = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Storage permission not granted');
    }
    String folder = await AppUtil.createFolderInIntDocDir('Recorder');
    var _file = new File('$folder/$_mPath');
    _mPath = _file.path;

    var hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener, debugLogging: true);

    if (hasSpeech) {
      _localeNames = await speech.locales();
      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    _myPlayer.openAudioSession().then((value) => setState(() {
          _myPlayerIsInited = true;
        }));

    openTheRecorder().then((value) {
      setState(() {
        _myRecorderIsInited = true;
      });
    });

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }

    await _myRecorder.openAudioSession();
    _myRecorderIsInited = true;
  }

  void resultListener(SpeechRecognitionResult result) {
    String sentence = result.recognizedWords;
    print('Result listened $sentence');
    _postBloc.add(DoPostEvent(sentence));
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

  void record() async {
    _myRecorder.startRecorder(toFile: _mPath).then((value) {
      setState(() {});
      print("Recording");
    });
  }

  void stopRecorder() async {
    await _myRecorder.stopRecorder().then((value) => {
          setState(() {
            _myPlaybackReady = true;
          })
        });
  }

  void play() async {
    assert(_myPlayerIsInited &&
        _myPlaybackReady &&
        _myRecorder.isStopped &&
        _myPlayer.isStopped);
    _myPlayer
        .startPlayer(
            fromURI: _mPath,
            whenFinished: () {
              setState(() {});
            })
        .then((value) => {setState(() {})});
  }

  void stopPlayer() {
    _myPlayer.stopPlayer().then((value) => setState(() {}));
  }

  _Fn getRecorderFn() {
    // print(
    //     '_myRecorderIsInited: $_myRecorderIsInited, _myPlayer.isStopped: ${_myPlayer.isStopped}');

    if (!_myRecorderIsInited || !_myPlayer.isStopped) {
      return null;
    }
    return _myRecorder.isStopped ? record : stopRecorder;
  }

  _Fn getPlayBackFn() {
    // print(
    //     '_myPlayerIsInited: $_myPlayerIsInited,_myPlaybackReady:$_myPlaybackReady,_myRecorder.isStopped: ${_myRecorder.isStopped} ');
    if (!_myPlayerIsInited || !_myPlaybackReady || !_myRecorder.isStopped) {
      return null;
    }
    return _myPlayer.isStopped ? play : stopPlayer;
  }

  @override
  void dispose() {
    _myPlayer.closeAudioSession();
    speech.cancel();

    _myPlayer = null;
    _myRecorder.closeAudioSession();
    _myRecorder = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(logic: SimpleHttpLogic()),
      child: SafeArea(
        child: SizedBox(
            width: double.infinity,
            child: BlocListener<PostBloc, PostState>(
              cubit: _postBloc,
              listener: (context, state) {
                if (state is PostedBlocState) {
                  print("${state.response["agressive"]} offensive");
                  if (state.response["agressive"]) {
                    print('It\'s on!');
                    record();
                  }
                }
              },
              child: BlocBuilder<PostBloc, PostState>(
                cubit: _postBloc,
                builder: (context, state) {
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
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RoundedButton(
                              color: Color(0xFFFFFFFFF),
                              iconData: _myPlayer.isPlaying
                                  ? Icons.stop
                                  : Icons.play_arrow,
                              onPressed: getPlayBackFn(),
                              mini: true,
                              bgColor: kSurfaceColor,
                            ),
                            RoundedButton(
                              bgColor: kPrimaryColor,
                              iconData: _myRecorder.isRecording
                                  ? Icons.stop
                                  : Icons.brightness_1,
                              onPressed: getRecorderFn(),
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
                        ),
                      ),
                    ],
                  );
                },
              ),
            )),
      ),
    );
  }
}
