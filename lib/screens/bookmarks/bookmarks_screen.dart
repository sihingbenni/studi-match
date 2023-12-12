import 'package:flutter/material.dart';
import 'package:studi_match/widgets/appbar/custom_appbar.dart';
import 'package:studi_match/widgets/lists/bookmark_list.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<BookmarksScreen> {

  @override
  Widget build(BuildContext context) => const Scaffold(
      appBar: CustomAppbar(leadingSearchIcon: true, actionAccountIcon: true, title: 'Deine Favoriten'),
      body: BookmarkList()
  );
}
