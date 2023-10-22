import 'package:flutter/material.dart';
import 'package:studi_match/widgets/lists/bookmark_list.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<BookmarksScreen> {

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.bookmark, color: Colors.yellow[800]),
        title: const Text('Bookmarks'),
      ),
      body: const BookmarkList()
  );
}
