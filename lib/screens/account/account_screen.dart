import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/screens/bookmarks/bookmarks_screen.dart';
import 'package:studi_match/widgets/router/nav_router.dart';

import '../authentication/authentication_screen.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
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
                            CircleAvatar(
                              radius: 35,
                              backgroundImage:
                                  NetworkImage(snapshot.data!.photoURL!),
                            ),
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
                                  '${snapshot.data?.displayName ?? ' '}👋',
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
                                      snapshot.data?.displayName ?? 'Kein Name',
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
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow[700]),
                        onPressed: () {
                          Navigator.of(context).push(
                            NavRouter(
                              builder: (context) => const BookmarksScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Zu meinen Bookmarks',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ))
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
                            builder: (context) => const AuthenticationPage(),
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
