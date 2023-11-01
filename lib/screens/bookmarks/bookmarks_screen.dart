import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/widgets/lists/bookmark_list.dart';

import '../../widgets/router/nav_router.dart';
import '../account/account_screen.dart';
import '../authentication/authentication_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<BookmarksScreen> {

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        actions: [
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.data?.isAnonymous ?? true) {
                return IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        NavRouter(
                          builder: (context) => const AuthenticationScreen(),
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
          ),
        ],
        title: const Text('Bookmarks'),
      ),
      body: const BookmarkList()
  );
}
