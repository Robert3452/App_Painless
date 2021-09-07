import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:painless_app/bloc/auth/auth_logic.dart';
import 'package:painless_app/screens/recorder/recorder.dart';
import 'package:painless_app/screens/recorder/widgets/login_avatar.dart';
import 'package:painless_app/bloc/auth/auth_bloc.dart';
import 'screen_recorder.dart';

class ProfileButton extends StatefulWidget {
  final VoidCallback logoutFn;

  ProfileButton(this.logoutFn);

  @override
  _ProfileButtonState createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  AuthBloc _authBloc = AuthBloc(authLogic: JWTAuth());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authLogic: JWTAuth()),
      child: BlocListener(
        bloc: _authBloc,
        listener: (context, state) {
          if (state is LoggedOutJWT || state is SignedOutGoogle) {
            // setState(() {
              widget.logoutFn();
            // });
          }
        },
        child: PopupMenuButton(
          onSelected: (value) {
            if (value == 0) {
              _authBloc.add(SignOutGoogle());
            }
          },
          initialValue: 2,
          child: LoginAvatar(),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 0,
                child: Text('Cerrar sesión'),
              ),
            ];
          },
        ),
      ),
    );
  }
}
