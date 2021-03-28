import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:intl/date_symbol_data_local.dart';

typedef _Fn = Function();

class TileItem extends StatefulWidget {
  final String nameFile;
  final String date;
  final String path;
  final int id;
  final String hour;

  const TileItem({
    Key key,
    this.nameFile,
    this.hour,
    this.date,
    this.id,
    this.path,
  }) : super(key: key);

  @override
  _TileItemState createState() => _TileItemState();
}

class _TileItemState extends State<TileItem> {
  bool stopped = true;

  List<Map<String, dynamic>> files;
  FlutterSoundPlayer _myPlayer = FlutterSoundPlayer();
  bool _myPlayerIsInitiated = false;
  bool _myPlaybackReady = false;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  Future<void> initPlayer() async {
    PermissionStatus status = await Permission.storage.request();
    if (status != PermissionStatus.granted)
      throw RecordingPermissionException('Microphone permission not granted');

    _myPlayer.openAudioSession().then((value) => setState(() {
          _myPlayerIsInitiated = true;
          _myPlaybackReady = true;
        }));
    await initializeDateFormatting();
  }

  Future<void> play() async {
    assert(_myPlayerIsInitiated && _myPlaybackReady);
    await _myPlayer.startPlayer(fromURI: widget.path);
    togglePlayer();
  }

  togglePlayer() {
    setState(() {
      stopped = !stopped;
    });
  }

  Future<void> stopPlayer() async {
    await _myPlayer.stopPlayer();
    togglePlayer();
  }

  _Fn getPlayBackFn() {
    print(_myPlayer.isStopped);
    if (!_myPlayerIsInitiated || !_myPlaybackReady) {
      return null;
    }
    return stopped ? play : stopPlayer;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.nameFile,
        style: TextStyle(color: kPrimaryLightColor),
      ),
      subtitle: Row(
        children: [
          //Hour text
          SizedBox(
            width: getProportionateScreenWidth(60),
            child: Text(
              widget.hour,
              style: TextStyle(color: kPrimaryLightColor),
            ),
          ),
          //Date Text
          Expanded(
            child: Text(
              widget.date,
              style: TextStyle(color: kPrimaryLightColor),
            ),
          ),
        ],
      ),
      leading: FloatingActionButton(
        heroTag: widget.id,
        onPressed: getPlayBackFn(),
        backgroundColor: Color.fromARGB(50, 255, 255, 255),
        mini: true,
        child: stopped ? Icon(Icons.play_arrow) : Icon(Icons.pause),
      ),
    );
  }
}
