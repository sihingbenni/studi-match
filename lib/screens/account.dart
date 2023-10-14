import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'authentication/authentication_page.dart';
import 'authentication/sign_up.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

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
      title: const Text('Dein Account', textAlign: TextAlign.center,),
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
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('You are logged in'),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                );
              } else {
           // User is not logged in
           return Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Text('You are not logged in'),
               ElevatedButton(
                 onPressed: () {
                   Navigator.of(context).push(
                     MaterialPageRoute(
                       builder: (context) => const SignUp(),
                     ),
                   );
                 },
                 child: const Text('Sign Up'),
               ),
               ElevatedButton(
                 onPressed: () {
                   Navigator.of(context).push(
                     MaterialPageRoute(
                       builder: (context) => const AuthenticationPage(),
                     ),
                   );
                 },
                 child: const Text('Login'),
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
