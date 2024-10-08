import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studi_match/providers/firebase_auth_provider.dart';
import 'package:studi_match/screens/account/onboarding_screen.dart';
import 'package:studi_match/screens/authentication/sign_in_screen.dart';
import 'package:studi_match/utilities/logger.dart';
import 'package:studi_match/utilities/snack_bar.dart';
import 'package:studi_match/widgets/router/nav_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                SvgPicture.asset(
                  'assets/images/undraw_sign_up.svg',
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                const Text(
                  'Willkommen 👋',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
                const Text(
                  'Jetzt anmelden, passende Angebote finden und deine Zukunft gestalten!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Füge eine gültige Email-Adresse hinzu'
                                : null,
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 6
                            ? 'Das Passwort sollte min. 6 Zeichen haben.'
                            : null,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                        onPressed: signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded,
                            color: Colors.white),
                        label: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Du hast bereits einen Account?'),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  NavRouter(
                                    builder: (context) => const SignInScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.green,
                                    decoration: TextDecoration.underline),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Future signUp() async {
    final isValid = formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }

    try {
      await FirebaseAuthProvider.authInstance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((value) {
        // remove all routes from the stack and push the onboarding screen
        Navigator.of(context).popUntil((route) => false);
        Navigator.of(context).push(
          NavRouter(
            builder: (context) => const OnBoardingScreen(),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      logger.e(e.message!);
      SnackBarUtil.showSnackBar(e.message!);
    }
  }
}
