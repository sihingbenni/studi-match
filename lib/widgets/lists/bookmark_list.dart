import 'package:flutter/material.dart';
import 'package:studi_match/models/bookmark.dart';
import 'package:studi_match/providers/bookmark_provider.dart';
import 'package:studi_match/utilities/logger.dart';

/// This widget displays the list of bookmarked jobs
class BookmarkList extends StatefulWidget {
  const BookmarkList({super.key});

  @override
  State<BookmarkList> createState() => _BookmarkListState();
}

class _BookmarkListState extends State<BookmarkList> {
  final _bookmarkProvider = BookmarkProvider();

  List<Bookmark> _bookmarkList = [];
  bool _allFetched = false;

  @override
  void initState() {
    _bookmarkProvider.addListener(() {
      // on change update the list of jobs
      setState(() {
        logger.d('updating bookmark list');
        _bookmarkList = _bookmarkProvider.bookmarkList;
        _allFetched = _bookmarkProvider.allFetched;
      });
    });
    _bookmarkProvider.getBookmarks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => NotificationListener<ScrollEndNotification>(
        child: ListView.builder(
            // if there are still bookmarks, add a loader at the end of the list (+1 item)
            itemCount: _bookmarkList.length + (_allFetched ? 0 : 1),
            itemBuilder: (context, index) {
              if (index == _bookmarkList.length) {
                return const SizedBox(
                  key: ValueKey('Loader'),
                  width: double.infinity,
                  height: 60,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              // set the item
              final bookmark = _bookmarkList[index];
              return ListTile(
                title: Text(bookmark.title),
                subtitle: Text(bookmark.employer),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _bookmarkProvider.removeBookmark(index);
                  },
                ),
              );
            }),
        onNotification: (scrollEnd) {
          if (!_allFetched && scrollEnd.metrics.atEdge && scrollEnd.metrics.pixels > 0) {
            logger.t('fetching more bookmarks');
            _bookmarkProvider.getBookmarks();
          }
          return true;
        },
      );
}
