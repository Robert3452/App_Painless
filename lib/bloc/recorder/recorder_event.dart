part of 'recorder_bloc.dart';


abstract class RecorderEvent extends Equatable {
  const RecorderEvent();
}

class DoRecordEvent extends RecorderEvent {
  final bool _isRecording;
  final bool _myRecorderIsInited;
  final bool _myPlayerIsStopped;

  DoRecordEvent(
      this._isRecording, this._myRecorderIsInited, this._myPlayerIsStopped);

  @override
  List<Object> get props => [_isRecording,_myRecorderIsInited,_myPlayerIsStopped];
}
