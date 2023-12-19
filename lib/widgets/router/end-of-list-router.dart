import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../screens/account/anonymous_account_screen.dart';
import '../../screens/account/logged_in_account_screen.dart';
import '../../screens/employment_agency/jobs_list_screen.dart';
import 'nav_router.dart';

class EndOfListRouter extends StatelessWidget {
  const EndOfListRouter({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text('Du hast alle passende Stellenanzeigen geswiped.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    NavRouter(
                      builder: (context) {
                        if (FirebaseAuth.instance.currentUser!.isAnonymous) {
                          return const AnonymousAccountScreen();
                        }
                        return const LoggedInAccountScreen();
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Ändere hier deine Präferenzen',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => {
                Navigator.of(context).pop(),
                Navigator.of(context).push(
                  NavRouter(
                    builder: (context) => const EAJobsListScreen(),
                  ),
                ),
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Beginne von vorne',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            )
          ],
        ),
      );
}
