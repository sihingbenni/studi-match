import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/providers/firebase_auth_provider.dart';

import '../../screens/account/account_screen.dart';
import '../../screens/authentication/authentication_screen.dart';
import '../router/nav_router.dart';

class AccountIcon extends StatelessWidget {
  const AccountIcon({super.key});

  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
        stream: FirebaseAuthProvider.authInstance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.data?.isAnonymous ?? true) {
            return IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    NavRouter(
                      builder: (context) => const AccountScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.person));
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              // User is logged in
              return FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context).push(
                    NavRouter(
                      builder: (context) => const AccountScreen(),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(2.0),
                  backgroundColor: Colors.transparent,
                ),
                child: snapshot.data?.photoURL != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data!.photoURL!),
                      )
                    : const Icon(Icons.person),
              );
            } else {
              // User is not logged in
              return IconButton(
                icon: const Icon(Icons.login),
                onPressed: () {
                  Navigator.of(context).push(
                    NavRouter(
                      builder: (context) => const AuthenticationScreen(),
                    ),
                  );
                },
              );
            }
          } else {
// Return a loading indicator while the authentication state is loading
            return const CircularProgressIndicator();
          }
        },
      );
}
