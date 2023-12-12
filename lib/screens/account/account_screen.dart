import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/widgets/appbar/custom_appbar.dart';
import 'package:studi_match/widgets/form/preference_form.dart';
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
    appBar: const CustomAppbar(leadingSearchIcon: true, actionAccountIcon: false, title: 'Dein Profil'),
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                // User is logged in
                return ListView(
                  padding: const EdgeInsets.all(16.0),
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
                                :
                            Container(
                              width: 50, // Adjust the size as needed
                              height: 50, // Adjust the size as needed
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey, // You can use a different shade of gray
                              ),
                              child: const Center(
                                child: Icon(Icons.person, size: 35, color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Hallo',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${snapshot.data?.displayName ?? snapshot.data?.email?.split('@').first ?? ' '} 👋',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(Icons.person),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      snapshot.data?.displayName ?? snapshot.data?.email?.split('@').first ?? 'Kein Name',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(Icons.mail),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      snapshot.data?.email ??
                                          'Keine E-Mail-Adresse',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow[700]),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        label: const Text('Ausloggen', style: TextStyle(color: Colors.white)),
                        icon: const Icon(Icons.logout, color: Colors.white),
                    ),
                    PreferenceForm(uuid: uuid),
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
