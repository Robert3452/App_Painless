part of 'phrase_bloc.dart';

abstract class PhraseState extends Equatable {
  const PhraseState();
}

class PhraseInitial extends PhraseState {
  @override
  List<Object> get props => [];
}

class GotPhrases extends PhraseState {
  final List<Map<String, dynamic>> phrases;

  GotPhrases(this.phrases);

  @override
  List<Object> get props => [phrases];
}

class PhraseCreated extends PhraseState {
  final Map<String, dynamic> response;

  PhraseCreated(this.response);

  @override
  List<Object> get props => [response];
}
