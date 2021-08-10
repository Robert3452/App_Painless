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
    if (event is GetPhrases) {
      try {
        var c =await phraseLogic.getPhrases();
        print(c);
        List<Map<String, dynamic>> response = c;
        yield GotPhrases(response);
      } catch (error) {
        yield PhraseException(error);
      }
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
