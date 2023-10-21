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

  String _getSwipedJobInfo(Bookmark bookmark, String swipeInfo) {
    int? nr = 0;
    switch (swipeInfo) {
      case 'views':
        nr = bookmark.swipedJobInfo?.views;
        break;
      case 'bookmarks':
        nr = bookmark.swipedJobInfo?.views;
        break;
      case 'detailViews':
        nr = bookmark.swipedJobInfo?.views;
        break;
      default:
        nr = 0;
    }

    if (nr == null) {
      return '0';
    }

    if (nr >= 1000) {
      return '999+';
    } else {
      return nr.toString();
    }
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
              return Dismissible(
                key: Key(bookmark.jobHashId),
                background: Container(
                    color: Colors.green,
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Icon(Icons.favorite, color: Colors.white),
                      ),
                    )),
                secondaryBackground: Container(
                    color: Colors.red,
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    )),
                child: ListTile(
                  title: Text(bookmark.title),
                  subtitle: Text(bookmark.employer),
                  leading: IconButton(
                    icon: Icon(bookmark.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: Colors.green),
                    onPressed: () {
                      _bookmarkProvider.toggleBookmarkLike(bookmark);
                    },
                  ),
                  visualDensity: VisualDensity.comfortable,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  trailing: FittedBox(
                    alignment: Alignment.centerRight,
                    fit: BoxFit.none,
                    child: IconTheme(
                      data: const IconThemeData(color: Colors.grey),
                      child: Column(
                        children: [
                          Row(children: [
                            const Icon(Icons.remove_red_eye_outlined),
                            const SizedBox(width: 5),
                            SizedBox(width: 25, child: Text(_getSwipedJobInfo(bookmark, 'views')))
                          ]),
                          Row(children: [
                            const Icon(Icons.bookmarks_outlined),
                            const SizedBox(width: 5),
                            SizedBox(
                                width: 25, child: Text(_getSwipedJobInfo(bookmark, 'bookmarks')))
                          ]),
                          Row(children: [
                            const Icon(Icons.pageview_outlined),
                            const SizedBox(width: 5),
                            SizedBox(
                                width: 25, child: Text(_getSwipedJobInfo(bookmark, 'detailViews')))
                          ]),
                        ],
                      ),
                    ),
                  ),
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
