import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'app_utils.dart';

class Recorder {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  int resultListened = 0;
  bool _isRecording = false;

  bool _myPlayerIsInited = false;
  bool _myRecorderIsInited = false;
  bool _myPlaybackReady = false;
  String _mPath = "last_recorded.mp3";
  SpeechToText speech;
  FlutterSoundPlayer _myPlayer;
  FlutterSoundRecorder _myRecorder;
  //constructor
  Recorder() {
    speech = SpeechToText();
    _myPlayer = FlutterSoundPlayer();
    _myRecorder = FlutterSoundRecorder();
  }

  Future<void> initRecorderState() async {
    var status = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Storage permission not granted');
    }
    String folder = await AppUtil.createFolderInIntDocDir('Recorder');
    var file = File('$folder/$_mPath');
    _mPath = file.path;

    var hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener, debugLogging: true);

    if (hasSpeech) {
      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    _myPlayer.openAudioSession().then((value) => _myRecorderIsInited = true);

    _hasSpeech = hasSpeech;
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

  void startListening() {
    lastWords = '';
    lastError = '';
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 10),
        pauseFor: Duration(seconds: 10),
        partialResults: false,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(minSoundLevel, level);
  }

  void resultListener(SpeechRecognitionResult result) {
    String sentence = result.recognizedWords;
    print('Result listened $sentence');
  }

  void errorListener(SpeechRecognitionError error) {
    lastError = '${error.errorMsg} - ${error.permanent}';
  }

  void statusListener(String status) {
    lastStatus = '$status';
  }
}
