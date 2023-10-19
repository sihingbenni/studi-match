import 'package:flutter/material.dart';
import 'package:studi_match/widgets/lists/bookmark_list.dart';
import 'package:studi_match/widgets/navigation/bottom_navigation_bar.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<BookmarksScreen> {
  int _currentNavigationIndex = 2;

  void _onNavigationTapped(int index) {
    setState(() {
      _currentNavigationIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.bookmark, color: Colors.yellow[800]),
        title: const Text('Bookmarks'),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentNavigationIndex,
        onItemTapped: _onNavigationTapped,
      ),
      body: const BookmarkList()
  );
}
