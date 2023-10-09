import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class AuthenticateUser extends StatefulWidget {
  const AuthenticateUser({super.key});

  @override
  State<AuthenticateUser> createState() => _AuthenticateUserState();
}

class _AuthenticateUserState extends State<AuthenticateUser> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SignInButtonBuilder(
            text: 'Get going with Email',
            icon: Icons.email,
            onPressed: () {
            },
            backgroundColor: Colors.blueGrey[700]!,
            width: 220.0,
          ),
          SignInButton(
            Buttons.Google,
            onPressed: () {
            },
          ),
          SignInButtonBuilder(
            text: 'Anonym bleiben',
            icon: Icons.login,
            onPressed: () {
            },
            backgroundColor: Colors.blueGrey[700]!,
            width: 220.0,
          ),
        ],
      ),
    ),
  );
}
