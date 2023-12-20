import 'package:flutter/material.dart';
import 'package:studi_match/providers/firebase_auth_provider.dart';

import '../../screens/authentication/authentication_screen.dart';
import '../router/nav_router.dart';

class LoggedOutAlert extends StatelessWidget {
  const LoggedOutAlert({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Ausloggen?'),
        backgroundColor: Colors.white,
        content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Bist du dir sicher, dass du dich ausloggen möchtest?'),
              const SizedBox(height: 8),
              Builder(builder: (context) {
                if (FirebaseAuthProvider.authInstance.currentUser!.isAnonymous) {
                  return const Text(
                      'Du wirst alle deine Favoriten und Einstellungen verlieren.');
                } else {
                  return const Text(
                      'Du kannst dich jederzeit erneut einloggen. Deine Einstellungen bleiben gespeichert!');
                }
              }),
            ]),
        actions: <Widget>[
          OutlinedButton(
              onPressed: () {
                FirebaseAuthProvider.authInstance.signOut();
                Navigator.of(context).popUntil((route) => false);
                Navigator.of(context).push(
                  NavRouter(
                    builder: (context) => const AuthenticationScreen(),
                  ),
                );
              },
              child: const Text('Ja', style: TextStyle(color: Colors.black87))),
          OutlinedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child:
                  const Text('Nein', style: TextStyle(color: Colors.black87))),
        ],
      );
}
