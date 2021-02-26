import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'recorder_event.dart';
part 'recorder_state.dart';

class RecorderBloc extends Bloc<RecorderEvent, RecorderState> {
  RecorderBloc() : super(RecorderInitial());

  @override
  Stream<RecorderState> mapEventToState(
    RecorderEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
