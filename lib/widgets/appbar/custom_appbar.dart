import 'package:flutter/material.dart';
import 'package:studi_match/screens/bookmarks/bookmarks_screen.dart';
import 'package:studi_match/screens/employment_agency/jobs_list_screen.dart';

import '../router/nav_router.dart';
import 'account-icon.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool leadingSearchIcon;
  final bool actionAccountIcon;
  final String title;

  const CustomAppbar({super.key, required this.leadingSearchIcon, required this.actionAccountIcon, required this.title});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    leading: leadingSearchIcon ? IconButton(
      icon: const Icon(Icons.search),
      color: Colors.yellow[800],
      iconSize: 32,
      onPressed: () {
        Navigator.of(context).push(
          NavRouter(
            builder: (context) => const EAJobsListScreen(),
          ),
        );
      },
    ) : const AccountIcon(),
    title: Text(title),
    actions: [
      actionAccountIcon ? const AccountIcon() :
      IconButton(
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
      ),
    ],
  );
}
