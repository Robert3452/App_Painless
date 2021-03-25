import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:painless_app/bloc/phrase/phrase_logic.dart';

part 'phrase_event.dart';

part 'phrase_state.dart';

class PhraseBloc extends Bloc<PhraseEvent, PhraseState> {
  final PhraseLogic phraseLogic;

  PhraseBloc({@required this.phraseLogic}) : super(PhraseInitial());

  @override
  Stream<PhraseState> mapEventToState(
    PhraseEvent event,
  ) async* {
    if (event is GetPhrase) {
      List<Map<String, dynamic>> response = await phraseLogic.getPhrases();
      yield GotPhrases(response);
    } else if (event is AddPhrase) {
      Map<String, dynamic> response = await phraseLogic.createPhrase(
          phrase: event.phrase,
          dateClassified: event.dateClassified,
          time: event.time,
          classifiedAs: event.classifiedAs);
      yield PhraseCreated(response);
    }
  }
}
