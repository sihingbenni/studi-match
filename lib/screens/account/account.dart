import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/widgets/navigation/bottom_navigation_bar.dart';

import '../authentication/authentication_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AuthenticationPage(),
                ),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
        bottomNavigationBar: CustomNavigationBar(
          currentIndex: _currentIndex,
          onItemTapped: _onItemTapped,
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
                                      fontWeight: FontWeight.bold, fontSize: 28),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${snapshot.data?.displayName}👋' ?? '👋',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 28),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(Icons.mail ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      snapshot.data?.email ?? 'Keine E-Mail-Adresse',
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
                          MaterialPageRoute(
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
