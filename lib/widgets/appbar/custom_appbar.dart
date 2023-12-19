import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/screens/authentication/authentication_screen.dart';
import 'package:studi_match/screens/bookmarks/bookmarks_screen.dart';
import 'package:studi_match/screens/home/home_screen.dart';

import '../router/nav_router.dart';
import 'account_icon.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool backButton;
  final bool actionAccountIcon;
  final bool userIsNotAnonymous;
  final bool userIsAnonymous;
  final bool actionBookmark;
  final String? title;

  const CustomAppbar(
      {super.key,
      required this.backButton,
      required this.actionAccountIcon,
      this.title,
      required this.userIsNotAnonymous,
      required this.userIsAnonymous,
      required this.actionBookmark});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        leading: backButton ? const BackButton() : const AccountIcon(),
        title: Builder(
          builder: (context) {
            if (title != null) {
              return Text(title!);
            }
            return const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_fire_department_outlined,
                  color: Colors.black87,
                  size: 32,
                ),
                Text(
                  'StudiMatch',
                  style: TextStyle(
                      fontSize: 24,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ],

            );
          }
        ),
        centerTitle: true,
        actions: [
          actionAccountIcon ? const AccountIcon()
              : userIsNotAnonymous
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
                  : userIsAnonymous
                      ? IconButton(
                          icon: const Icon(Icons.logout),
                          iconSize: 32,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Ausloggen?'),
                                      content: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Bist du dir sicher, dass du dich ausloggen möchtest?'),
                                            SizedBox(height: 8),
                                            Text('Du wirst alle deine Favoriten und Einstellungen verlieren.'),
                                          ]),
                                      actions: <Widget>[
                                        ElevatedButton(
                                            onPressed: () {
                                              FirebaseAuth.instance.signOut();
                                              Navigator.of(context)
                                                  .popUntil((route) => false);
                                              Navigator.of(context).push(
                                                NavRouter(
                                                  builder: (context) =>
                                                      const AuthenticationScreen(),
                                                ),
                                              );
                                            },
                                            child: const Text('Ja')),
                                        ElevatedButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text('Nein')),
                                      ],
                                    ));
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
