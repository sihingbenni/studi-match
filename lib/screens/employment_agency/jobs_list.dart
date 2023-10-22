import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/screens/account/account.dart';
import 'package:studi_match/screens/authentication/authentication_page.dart';
import 'package:studi_match/widgets/lists/swipe_list.dart';

import '../../widgets/router/nav_router.dart';

class EAJobsListScreen extends StatelessWidget {
  const EAJobsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.data?.isAnonymous ?? true) {
                return IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        NavRouter(
                          builder: (context) => const AuthenticationPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.login));
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  // User is logged in
                  return FilledButton.tonal(
                    onPressed: () {
                      Navigator.of(context).push(
                        NavRouter(
                          builder: (context) => const AccountPage(),
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
                            backgroundImage:
                                NetworkImage(snapshot.data!.photoURL!),
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
                          builder: (context) => const AuthenticationPage(),
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
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list_rounded),
              onPressed: () {},
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                NavRouter(
                  builder: (context) => const EAJobsListScreen(),
                ));
          },
          child: const Icon(Icons.refresh),
        ),
        body: const SwipeList(),
      );
}
