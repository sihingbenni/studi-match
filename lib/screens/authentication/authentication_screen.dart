import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';
import 'package:studi_match/providers/firebase_auth_provider.dart';
import 'package:studi_match/screens/account/onboarding_screen.dart';
import 'package:studi_match/screens/authentication/sign_in_screen.dart';
import 'package:studi_match/screens/authentication/sign_up_screen.dart';
import 'package:studi_match/screens/employment_agency/jobs_list_screen.dart';
import 'package:studi_match/screens/home/home_screen.dart';
import 'package:studi_match/utilities/logger.dart';
import 'package:studi_match/widgets/router/nav_router.dart';

import '../../providers/google_sign_in.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(
                NavRouter(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SvgPicture.asset(
                    'assets/images/undraw_mobile_encryption.svg',
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hallo 👋',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'und willkommen zu Studi Match. Logge dich ein oder erstelle ein Account, um passende Angebote zu finden und deine Zukunft zu gestalten!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            NavRouter(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        },
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
                      const SizedBox(
                        height: 8,
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
                  const SizedBox(
                    height: 8,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text(
                        'Oder fahre mit den folgenden Möglichkeiten fort:',
                        style: TextStyle(fontSize: 16),
                      ),
                      SignInButton.mini(
                          buttonType: ButtonType.google,
                          onPressed: () {
                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            provider.googleLogin().then((value) {
                              // check if the login was successful
                              if (FirebaseAuthProvider
                                      .authInstance.currentUser ==
                                  null) {
                                logger.w('Google Login failed');
                                return;
                              }
                              // remove all routes from the stack and push the onboarding screen
                              Navigator.of(context).popUntil((route) => false);
                              Navigator.of(context).push(
                                NavRouter(
                                  builder: (context) =>
                                      const EAJobsListScreen(),
                                ),
                              );
                            });
                          }),
                      TextButton(
                        onPressed: () {
                          try {
                            FirebaseAuthProvider.authInstance
                                .signInAnonymously()
                                .then((value) {
                              logger.i('Du bist nun authentifiziert.');
                              // remove all routes from the stack and push the onboarding screen
                              Navigator.of(context).popUntil((route) => false);
                              Navigator.of(context).push(
                                NavRouter(
                                  builder: (context) =>
                                      const OnBoardingScreen(),
                                ),
                              );
                            });
                          } on Exception catch (_) {
                            throw Exception(
                                'Anonymer Login hat nicht funktioniert.');
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'bleib anonym',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            ),
                            Text(' 🕵', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
