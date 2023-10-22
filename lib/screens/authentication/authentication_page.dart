import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';
import 'package:studi_match/screens/authentication/sign_up.dart';
import 'package:studi_match/screens/employment_agency/jobs_list.dart';
import 'package:studi_match/screens/home/home.dart';
import 'package:studi_match/utilities/logger.dart';
import 'package:studi_match/widgets/router/nav_router.dart';

import '../../providers/google_sign_in.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(
                NavRouter(
                  builder: (context) => const Home(),
                ),
              );
            },
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            SizedBox(
              // TODO: better way to set height
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    'assets/images/undraw_mobile_encryption.svg',
                    width: 300,
                    height: 300,
                  ),
                  const Text(
                    'Hallo 👋',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                  const Text(
                    'und willkommen zu Studi Match. Logge dich ein oder erstelle ein Account, um passende Angebote zu finden und deine Zukunft zu gestalten!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Anmelden',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              NavRouter(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            side: const BorderSide(
                              color: Colors.greenAccent,
                              width: 2,
                            ),
                          ),
                          child: const Text('Account erstellen',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent)),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Oder fahre mit den folgenden Möglichkeiten fort:',
                        style: TextStyle(fontSize: 16),
                      ),
                      SignInButton.mini(
                          buttonType: ButtonType.google,
                          onPressed: () {
                            final provider =
                                Provider.of<GoogleSignInProvider>(context, listen: false);
                            provider.googleLogin().then((value) => Navigator.of(context).push(
                                  NavRouter(
                                    builder: (context) => const EAJobsListScreen(),
                                  ),
                                ));
                          }),
                      TextButton(
                        onPressed: () {
                          try {
                            FirebaseAuth.instance.signInAnonymously().then((value) {
                              logger.i('Du bist nun authentifiziert.');
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                NavRouter(
                                  builder: (context) => const EAJobsListScreen(),
                                ),
                              );
                            });
                            // TODO: Loading indicator and pop up upon successful login
                          } on Exception catch (_) {
                            throw Exception(const Text('Anonymer Login hat nicht funktioniert.'));
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'bleib anonym',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            ),
                            Text('🥷', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
