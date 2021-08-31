part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class SignInJWT extends AuthEvent {
  final String email;
  final String password;

  SignInJWT(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignInGoogle extends AuthEvent {
  @override
  List<Object> get props => [];
}

class SignOutGoogle extends AuthEvent {
  @override
  List<Object> get props => [];
}

class SignUpJWT extends AuthEvent {
  final String email;
  final String password;
  final String confirm_pwd;
  final String names;
  final String lastName;

  SignUpJWT(
      this.email, this.password, this.confirm_pwd, this.names, this.lastName);

  @override
  List<Object> get props => [email, password, names];
}

class LogoutJWT extends AuthEvent {
  @override
  List<Object> get props => [];
}
