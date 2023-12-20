import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/widgets/accounts/anonymous_account.dart';
import 'package:studi_match/widgets/accounts/logged_in_account.dart';
import 'package:studi_match/widgets/appbar/custom_appbar.dart';
import 'package:studi_match/widgets/router/nav_router.dart';

import '../authentication/authentication_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final String uuid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const CustomAppbar(
            backButton: true,
            actionAccountIcon: false,
            logOutIcon: true,
            actionBookmark: false,
            title: 'Dein Profil'),
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.data?.isAnonymous ?? true) {
              return AnonymousAccount(uuid: uuid);
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                // User is logged in
                return LoggedInAccount(uuid: uuid);
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
