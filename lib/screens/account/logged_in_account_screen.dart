import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/screens/account/anonymous_account_screen.dart';
import 'package:studi_match/widgets/appbar/custom_appbar.dart';
import 'package:studi_match/widgets/form/preference_form.dart';
import 'package:studi_match/widgets/router/nav_router.dart';

import '../authentication/authentication_screen.dart';

class LoggedInAccountScreen extends StatefulWidget {
  const LoggedInAccountScreen({super.key});

  @override
  State<LoggedInAccountScreen> createState() => _LoggedInAccountScreenState();
}

class _LoggedInAccountScreenState extends State<LoggedInAccountScreen> {
  final String uuid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const CustomAppbar(
            backButton: true,
            actionAccountIcon: false,
            actionSignIn: false,
            actionSignOut: true,
            actionBookmark: false,
            title: 'Dein Profil'),
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.data?.isAnonymous ?? true) {
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
                          builder: (context) => const AnonymousAccountScreen(),
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
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                // User is logged in
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  snapshot.data!.photoURL != null
                                      ? const CircleAvatar(
                                          radius: 35,
                                          child: Icon(
                                            Icons.person,
                                            size: 35,
                                          ),
                                        )
                                      : Container(
                                          width: 50, // Adjust the size as needed
                                          height: 50, // Adjust the size as needed
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors
                                                .grey, // You can use a different shade of gray
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.person,
                                                size: 35, color: Colors.white),
                                          ),
                                        )
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Hallo ${snapshot.data?.displayName ??
                                            snapshot.data?.email?.split('@').first ??
                                            ''} 👋',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.person),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Text(
                                                snapshot.data?.displayName ??
                                                    snapshot.data?.email
                                                        ?.split('@')
                                                        .first ??
                                                    'Kein Name',
                                                style:
                                                    const TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.mail),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Text(
                                                snapshot.data?.email ??
                                                    'Keine E-Mail-Adresse',
                                                style:
                                                    const TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          PreferenceForm(uuid: uuid),
                        ],
                      ),
                    ],
                  ),
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
