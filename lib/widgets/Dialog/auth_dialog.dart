import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:studi_match/widgets/Dialog/onboarding_dialog.dart';

class AuthenticationDialog extends StatefulWidget {
  const AuthenticationDialog({super.key});

  @override
  State<AuthenticationDialog> createState() => _AuthenticationDialogState();
}

class _AuthenticationDialogState extends State<AuthenticationDialog> {
  @override
  Widget build(BuildContext context) =>
      ElevatedButton(onPressed: () => showAuthenticationDialog(context),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              padding: const EdgeInsets.symmetric(
                  horizontal: 40, vertical: 10)),
          child: const Text(
            'Jetzt starten!',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ));

  void showAuthenticationDialog(BuildContext context) =>
      showDialog(
          context: context,
          builder: (context) =>
              StatefulBuilder(
                  builder: (context, setState) =>
                      Dialog(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SignInButtonBuilder(
                                text: 'Get going with Email',
                                icon: Icons.email,
                                onPressed: () {
                                },
                                backgroundColor: Colors.greenAccent[700]!,
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
                                },
                                backgroundColor: Colors.greenAccent[700]!,
                                width: 220.0,
                              ),
                            ],
                          ),
                        ),
                      )
              ));
}
