import 'package:flutter/material.dart';
import 'package:studi_match/screens/bookmarks/bookmarks_screen.dart';
import 'package:studi_match/widgets/dialogs/logged-out-alert.dart';

import '../router/nav_router.dart';
import 'account_icon.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool backButton;
  final bool actionAccountIcon;
  final bool logOutIcon;
  final bool actionBookmark;
  final String? title;

  const CustomAppbar(
      {super.key,
      required this.backButton,
      required this.actionAccountIcon,
      this.title,
      required this.logOutIcon,
      required this.actionBookmark});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        leading: backButton ? const BackButton() : const AccountIcon(),
        title: Builder(builder: (context) {
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
        }),
        centerTitle: true,
        actions: [
          actionAccountIcon
              ? const AccountIcon()
              : logOutIcon
                  ? IconButton(
                      icon: const Icon(Icons.logout),
                      iconSize: 32,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const LoggedOutAlert(),
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
                                builder: (context) => const BookmarksScreen(),
                              ),
                            );
                          },
                        )
                      : Container(),
        ],
      );
}
