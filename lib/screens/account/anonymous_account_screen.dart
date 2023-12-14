import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/screens/account/logged_in_account_screen.dart';
import 'package:studi_match/widgets/appbar/custom_appbar.dart';
import 'package:studi_match/widgets/form/preference_form.dart';
import 'package:studi_match/widgets/router/nav_router.dart';

import '../authentication/authentication_screen.dart';

class AnonymousAccountScreen extends StatefulWidget {
  const AnonymousAccountScreen({super.key});

  @override
  State<AnonymousAccountScreen> createState() => _AnonymousAccountScreenState();
}

class _AnonymousAccountScreenState extends State<AnonymousAccountScreen> {
  final String uuid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const CustomAppbar(
        backButton: true,
        actionAccountIcon: false,
        userIsAnonymous: true,
        userIsNotAnonymous: false,
        actionBookmark: false,
        title: 'Das könnte dein Profil sein'),
    body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.data?.isAnonymous ?? true) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text('Hallo 👋',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28)),
                    const Text(
                        'Du bist anonym unterwegs. Wenn du die volle Kraft '
                            'unserer App austesten möchtest, dann musst du '
                            'dich anmelden!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 20),
                    PreferenceForm(uuid: uuid),
                  ],
                ),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // User is logged in
            return AlertDialog(
              title: const Text('Du hast dich leider verlaufen.'),
              content: const Text(
                'Um diese Funktion nutzen zu können, klicke bitte auf "Weiter".',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      NavRouter(
                        builder: (context) => const LoggedInAccountScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Weiter',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            );
          } else {
            // User is not logged in
            return AlertDialog(
              backgroundColor: Colors.greenAccent[100],
              title: const Text('Du bist leider nicht eingeloggt.'),
              content: const Text(
                'Um diese Funktion nutzen zu können, musst du dich einloggen.',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      NavRouter(
                        builder: (context) => const AuthenticationScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Jetzt einloggen',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            );
          }
        } else {
          // Loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ),
  );
}
