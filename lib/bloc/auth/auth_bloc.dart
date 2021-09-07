import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:painless_app/bloc/auth/auth_logic.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthLogic authLogic;

  AuthBloc({@required this.authLogic}) : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is SignInJWT) {
      Map<String, dynamic> response =
          await authLogic.signIn(event.email, event.password);
      yield LoggedInJWT(response);
    } else if (event is SignUpJWT) {
      Map<String, dynamic> response = await authLogic.signUp(event.email,
          event.password, event.confirm_pwd, event.names, event.lastName);
      yield SignedUpJWT(response);
    } else if (event is SignInGoogle) {
      Map<String, dynamic> response = await authLogic.signInGoogle();
      yield SigningInGoogle(response);
    } else if (event is SignOutGoogle) {
      await authLogic.signOutGoogle();
      yield SignedOutGoogle();
    } else if (event is LogoutJWT) {
      Map<String, dynamic> response = await authLogic.logout();
      yield LoggedOutJWT(response);
    }
  }
}
