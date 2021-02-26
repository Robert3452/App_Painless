part of 'post_bloc.dart';

@immutable
abstract class PostEvent extends Equatable {
  const PostEvent();
}

class DoPostEvent extends PostEvent {
  final String sentence;

  DoPostEvent(this.sentence);
  @override
  List<Object> get props => [sentence];
}
