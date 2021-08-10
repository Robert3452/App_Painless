part of 'phrase_bloc.dart';

abstract class PhraseEvent extends Equatable {
  const PhraseEvent();
}

class GetPhrases extends PhraseEvent {
  @override
  List<Object> get props => [];
}

class AddPhrase extends PhraseEvent {
  final String phrase;
  final String dateClassified;
  final String time;
  final bool classifiedAs;

  AddPhrase(this.phrase, this.dateClassified, this.time, this.classifiedAs);
  @override
  List<Object> get props => throw [phrase, dateClassified, time, classifiedAs];
}
