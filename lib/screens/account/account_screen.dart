import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/screens/home/home_screen.dart';
import 'package:studi_match/widgets/appbar/custom_appbar.dart';
import 'package:studi_match/widgets/picker/preference_picker.dart';
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
            leadingSearchIcon: true,
            actionAccountIcon: false,
            title: 'Dein Profil'),
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.data?.isAnonymous ?? true) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text('Hallo 👋',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28)),
                    const Text(
                        'Du bist anonym unterwegs. Wenn du dich ausloggst dann verlierst du deine Daten.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 20),
                    PreferencePicker(uuid: uuid),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).push(NavRouter(
                          builder: (context) => const AuthenticationScreen(),
                        ));
                      },
                      label: const Text('Einloggen',
                          style: TextStyle(color: Colors.white)),
                      icon: const Icon(Icons.login, color: Colors.white),
                    ),
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                // User is logged in
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
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
                      PreferencePicker(uuid: uuid),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700],
                          minimumSize: const Size(double.infinity, 40),
                        ),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).push(NavRouter(
                            builder: (context) => const HomeScreen(),
                          ));
                        },
                        label: const Text('Ausloggen',
                            style: TextStyle(color: Colors.white)),
                        icon: const Icon(Icons.logout, color: Colors.white),
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
