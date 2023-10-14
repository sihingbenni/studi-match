import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sign_button/sign_button.dart';

import '../../widgets/Dialog/onboarding_dialog.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                        'assets/images/undraw_mobile_encryption.svg',
                        width: 300,
                        height: 300,
                      ) ??
                      Text('Failed to load image'),
                  const Text(
                    'Hallo 👋',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                  SizedBox(
                    child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                        ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                              color: Colors.greenAccent,
                              width: 2,
                            )),
                            child: const Text('Sign Up',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent))),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      children: [
                        const Text(
                          'Oder fahre mit den folgenden Möglichkeiten fort:',
                          style: TextStyle(fontSize: 16),
                        ),
                        SignInButton.mini(
                            buttonType: ButtonType.google, onPressed: () {}),
                        TextButton(
                            onPressed: () {
                              try {
                                FirebaseAuth.instance
                                    .signInAnonymously()
                                    .then((value) {
                                  print('Du bist nun authentifiziert.');
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const OnboardingDialog(),
                                  ));
                                });
                                // TODO: Loading indicator and pop up upon successfull login
                              } on Exception catch (_) {
                                throw Exception(const Text(
                                    'Anonymer Login hat nicht funktioniert.'));
                              }
                            },
                            child: const Text(
                              'bleib anonym 🥷',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
}
