import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_button/sign_button.dart';

import '../../widgets/Dialog/onboarding_dialog.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Hallo 👋', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              SignInButton(buttonType: ButtonType.mail, onPressed: () {}),
              SignInButton.mini(buttonType: ButtonType.google, onPressed: () {}),
              TextButton(onPressed: () {
                try {
                  FirebaseAuth.instance.signInAnonymously()
                      .then((value) {
                    print('Du bist nun authentifiziert.');
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (
                              context) => const OnboardingDialog(),
                        ));
                  });
                  // TODO: Loading indicator and pop up upon successfull login
                } on Exception catch (_) {
                  throw Exception(const Text(
                      'Anonymer Login hat nicht funktioniert.'));
                }
              }, child: const Text('oder bleib anonym', style: TextStyle(color: Colors.black),)),
            ],
          ),
        ],
      ),
    );
}
