part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class SigningInGoogle extends AuthState{
  final Map<String, dynamic> response;
  SigningInGoogle(this.response);
  @override
  List<Object> get props => [response];
}

class SignedOutGoogle extends AuthState{

  @override
  List<Object> get props => [];

}

class SignedUpJWT extends AuthState {
  final Map<String, dynamic> response;

  SignedUpJWT(this.response);

  @override
  List<Object> get props => [response];
}

class LoggedInJWT extends AuthState {
  final Map<String, dynamic> response;

  LoggedInJWT(this.response);

  @override
  List<Object> get props => [response];
}

class LoggedOutJWT extends AuthState {
  final Map<String, dynamic> response;

  LoggedOutJWT(this.response);

  @override
  List<Object> get props => [response];
}
//
// class SignUpInitJWT extends AuthState {
//   @override
//   List<Object> get props => [];
// }
//
// class LoginInJWT extends AuthState {
//   @override
//   List<Object> get props => [];
// }
//
// class LogoutInJWT extends AuthState {
//   @override
//   List<Object> get props => [];
// }
