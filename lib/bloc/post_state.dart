part of 'post_bloc.dart';

@immutable
abstract class PostState extends Equatable {
  const PostState();
}

class PostInitial extends PostState {
  @override
  List<Object> get props => [];
}

class PostBlocState extends PostState {
  @override
  List<Object> get props => [];
}

class PostedBlocState extends PostState {
  final Map<String, dynamic> response;
  
  PostedBlocState(this.response);

  @override
  List<Object> get props => [response];
}

class PostErrorState extends PostState{
  final Map<String, dynamic> error;

  PostErrorState(this.error);

  @override
  List<Object> get props => [error];

}
