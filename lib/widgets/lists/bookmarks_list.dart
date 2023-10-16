import 'package:flutter/material.dart';
import 'package:studi_match/models/bookmark.dart';
import 'package:studi_match/providers/bookmark_provider.dart';

/// This widget displays the list of bookmarked jobs
class BookmarkList extends StatefulWidget {
  const BookmarkList({super.key});

  @override
  State<BookmarkList> createState() => _BookmarkListState();
}

class _BookmarkListState extends State<BookmarkList> {
  final bookmarkProvider = BookmarkProvider();

  List<Bookmark> bookmarkList = [];

  @override
  void initState() {
    bookmarkProvider.getBookmarks();
    bookmarkProvider.addListener(() {
      // on change update the list of jobs
      setState(() {
        bookmarkList = bookmarkProvider.bookmarkList;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
      itemCount: bookmarkProvider.bookmarkList.length,
      itemBuilder: (context, index) {
        final bookmark = bookmarkProvider.bookmarkList[index];
        return ListTile(
          title: Text(bookmark.title),
          subtitle: Text(bookmark.employer),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              bookmarkProvider.removeBookmark(index);
            },
          ),
        );
      });
}
