import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/screens/account/account.dart';
import 'package:studi_match/screens/bookmarks/bookmarks.dart';
import 'package:studi_match/screens/employment_agency/jobs_list.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const CustomNavigationBar(
      {super.key, required this.currentIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) => Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.greenAccent[100],
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            ),
          ],
        ),
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.data?.isAnonymous ?? true) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Du bist anonym unterwegs.',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text(
                      'Melde dich an, um alle Funktionalitäten zu nutzen.',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.account_circle, 'Account', context),
                  _buildNavItem(1, Icons.search, 'Search', context),
                  _buildNavItem(2, Icons.bookmark, 'Bookmarks', context),
                ],
              );
            }
          },
        ),
      );

  Widget _buildNavItem(
          int index, IconData icon, String label, BuildContext context) =>
      InkWell(
        onTap: () {
          onItemTapped(index);
          if (index == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AccountPage()));
          } else if (index == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EAJobsListScreen()));
          } else if (index == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BookmarksScreen(key: Key('bookmarks_screen'),)));
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: index == currentIndex ? Colors.green[900] : Colors.grey,
              size: 30,
            ),
            Text(
              label,
              style: TextStyle(
                color: index == currentIndex ? Colors.green[900] : Colors.grey,
              ),
            ),
          ],
        ),
      );
}

class AccountScreen {}
