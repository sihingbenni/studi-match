import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/screens/authentication/authentication_screen.dart';
import 'package:studi_match/screens/bookmarks/bookmarks_screen.dart';
import 'package:studi_match/screens/home/home_screen.dart';

import '../router/nav_router.dart';
import 'account-icon.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool backButton;
  final bool actionAccountIcon;
  final bool actionSignOut;
  final bool actionSignIn;
  final bool actionBookmark;
  final String title;

  const CustomAppbar(
      {super.key,
      required this.backButton,
      required this.actionAccountIcon,
      required this.title,
      required this.actionSignOut,
      required this.actionSignIn,
      required this.actionBookmark});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        leading: backButton ? const BackButton() : const AccountIcon(),
        title: Text(title),
        actions: [
          actionAccountIcon
              ? const AccountIcon()
              : actionSignOut
                  ? IconButton(
                      icon: const Icon(Icons.logout),
                      iconSize: 32,
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).push(
                          NavRouter(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                    )
                  : actionSignIn
                      ? IconButton(
                          icon: const Icon(Icons.login),
                          iconSize: 32,
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context).push(
                              NavRouter(
                                builder: (context) =>
                                    const AuthenticationScreen(),
                              ),
                            );
                          },
                        )
                      : actionBookmark
                          ? IconButton(
                              icon: const Icon(Icons.bookmarks),
                              color: Colors.yellow[800],
                              iconSize: 32,
                              onPressed: () {
                                Navigator.of(context).push(
                                  NavRouter(
                                    builder: (context) =>
                                        const BookmarksScreen(),
                                  ),
                                );
                              },
                            )
                          : Container(),
        ],
      );
}
