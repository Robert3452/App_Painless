import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:painless_app/bloc/auth/auth_bloc.dart';
import 'package:painless_app/bloc/auth/auth_logic.dart';
import 'package:painless_app/bloc/phrase/phrase_bloc.dart';
import 'package:painless_app/bloc/phrase/phrase_logic.dart';
import 'package:painless_app/screens/record_files/record_files.dart';
import 'package:painless_app/screens/recorder/widgets/appbar_recorder.dart';
import 'package:painless_app/screens/recorder/widgets/floating_buttons.dart';
import 'package:painless_app/screens/recorder/widgets/init_speech_button.dart';
import 'package:painless_app/screens/recorder/widgets/rounded_button.dart';
import 'package:painless_app/screens/recorder/widgets/screen_recorder.dart';
import 'package:painless_app/utils/app_utils.dart';
import '../../../constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_sound/flutter_sound.dart';
import '../../../bloc/api/post_logic.dart';
import '../../../bloc/api/post_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

// import '../../../widgets/toast.dart';
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
  final SpeechToText speech = SpeechToText();
  bool _hasSpeech = false;
  double level = 0.0;
  String phrase = "";
  bool signed = false;
  StreamSubscription _recorderSubscription;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  int resultListened = 0;
  bool _isRecording = false;
  PostBloc _postBloc = PostBloc(logic: SimpleHttpLogic());
  AuthBloc _authBloc = AuthBloc(authLogic: JWTAuth());
  PhraseBloc _phraseBloc = PhraseBloc(phraseLogic: HttpPhraseLogic());
  bool created = false;
  List<LocaleName> _localeNames = [];
  String _recorderTxt = "00:00:00";
  double _dbLevel;
  FlutterSoundPlayer _myPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder _myRecorder = FlutterSoundRecorder();

  bool _myPlayerIsInited = false;
  bool _myRecorderIsInited = false;
  bool _myPlaybackReady = false;
  String _mPath = "flutter_sound_example.mp3";
  String _pathFolder;

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
    _pathFolder = await AppUtil.createInternalDir('Recorder');

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
    await initializeDateFormatting();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }

    await _myRecorder.openAudioSession();
    await _myRecorder.setSubscriptionDuration(Duration(milliseconds: 10));

    _myRecorderIsInited = true;
  }

  void resultListener(SpeechRecognitionResult result) {
    String sentence = result.recognizedWords;
    print('Result listened $sentence');
    setState(() {
      phrase = sentence;
    });
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
    String newFile = await AppUtil.createFile(_pathFolder);
    _myRecorder.startRecorder(toFile: newFile).then((value) {
      setState(() {});
      print("Recording");
    });
    _recorderSubscription = _myRecorder.onProgress.listen((event) {
      if (event != null && event.duration != null) {
        var date = DateTime.fromMillisecondsSinceEpoch(
            event.duration.inMilliseconds,
            isUtc: true);
        var txt = DateFormat("mm:ss:SS", "es_US").format(date);
        setState(() {
          _recorderTxt = txt.substring(0, 8);
          _dbLevel = event.decibels;
        });
      }
    });
  }

  void stopRecorder() async {
    await _myRecorder.stopRecorder().then((value) => {
          setState(() {
            _isRecording = false;
            _recorderTxt = "00:00:00";
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
    if (!_myRecorderIsInited || !_myPlayer.isStopped) {
      return null;
    }
    return _myRecorder.isStopped ? record : stopRecorder;
  }

  _Fn getPlayBackFn() {
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PostBloc(logic: SimpleHttpLogic())),
        BlocProvider(create: (context) => AuthBloc(authLogic: JWTAuth()))
      ],
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: MultiBlocListener(
            listeners: [
              BlocListener(
                  cubit: _phraseBloc,
                  listener: (context, state) {
                    print('hola bloc phrases');
                    if (state is PhraseCreated) {
                      setState(() {
                        created = true;
                        print('phrase created');
                      });
                    }
                  }),
              BlocListener(
                cubit: _authBloc,
                listener: (context, state) {
                  print('hola bloc auth $signed');

                  if (state is SignedUpJWT) {
                    setState(() {
                      signed = state.response['message'];
                    });
                  }
                  if (state is LoggedInJWT) {
                    setState(() {
                      signed = state.response['message'];
                      print('signed $signed');
                    });
                  }
                },
              ),
              BlocListener(
                cubit: _postBloc,
                listener: (context, state) {
                  print('hola bloc post aggression');
                  if (state is PostedBlocState) {
                    print("${state.response["agressive"]} offensive");
                    setState(() {
                      _isRecording = state.response["agressive"];
                    });
                    _savePhrase();
                    if (_isRecording) {
                      print('It\'s on!');
                      record();
                      if (signed) {
                        _savePhrase();
                      }
                    }
                  }
                },
              )
            ],
            child: BlocBuilder<PostBloc, PostState>(
              cubit: _postBloc,
              builder: (context, state) {
                return Column(
                  children: [
                    AppbarRecorder(),
                    ScreenRecorder(
                      isRecording: _isRecording,
                      timer: _recorderTxt,
                    ),
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
                            iconData: Icons.dashboard,
                            onPressed: null,
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
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RecordFiles.routeName);
                            },
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
          ),
        ),
      ),
    );
  }

  void _savePhrase() {
    DateTime now = DateTime.now();
    _phraseBloc.add(AddPhrase(phrase, AppUtil.toDateString(now),
        AppUtil.toHourString(now, ":"), _isRecording));
  }
}
