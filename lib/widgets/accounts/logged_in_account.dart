import 'package:flutter/material.dart';
import 'package:studi_match/providers/firebase_auth_provider.dart';
import 'package:studi_match/widgets/dialogs/false_redirect-alert.dart';

import '../form/preference_form.dart';

class LoggedInAccount extends StatelessWidget {
  final String uuid;

  const LoggedInAccount({super.key, required this.uuid});

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: FirebaseAuthProvider.authInstance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
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
                                  'Hallo ${snapshot.data?.displayName ?? snapshot.data?.email?.split('@').first ?? ''} 👋',
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
                                          style: const TextStyle(fontSize: 16),
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
                                          style: const TextStyle(fontSize: 12),
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
          return const FalseDirectAlert();
        }
      });
}
