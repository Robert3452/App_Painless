import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'post_logic.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostLogic logic;

  PostBloc({@required this.logic}) : super(PostInitial());

  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    if (event is DoPostEvent) {
      yield PostBlocState();
      try {
        var response = await logic.sendAggression(event.sentence);
        yield PostedBlocState(response);
      } on HttpException {
        yield PostErrorState(
            {"message": "No pudo realizarse el envío de data", "error": 500});
      }
    }
  }
}
