import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/models/bookmark.dart';
import 'package:studi_match/models/job.dart';
import 'package:studi_match/providers/bookmark_provider.dart';
import 'package:studi_match/providers/pastel_color_provider.dart';
import 'package:studi_match/providers/single_job_provider.dart';
import 'package:studi_match/utilities/logger.dart';
import 'package:studi_match/widgets/details/back_card.dart';
import 'package:studi_match/widgets/details/front_card.dart';
import 'package:studi_match/widgets/dialogs/delete_bookmark_dialog.dart';

/// This widget displays the list of bookmarked jobs
class BookmarkList extends StatefulWidget {
  const BookmarkList({super.key});

  @override
  State<BookmarkList> createState() => _BookmarkListState();
}

class _BookmarkListState extends State<BookmarkList> {
  final _bookmarkProvider = BookmarkProvider();
  final _singleJobProvider = SingleJobProvider();

  Job? _job;

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
    _singleJobProvider.addListener(() {
      setState(() {
        _job = _singleJobProvider.job;
        logger.f('got job details for ${_job!.hashId}');
      });
    });

    _bookmarkProvider.getBookmarks();
    super.initState();
  }

  String _formatNumber(int? nr) {
    if (nr == null) {
      return '0';
    } else if (nr >= 1000) {
      return '999+';
    } else {
      return nr.toString();
    }
  }

  @override
  Widget build(BuildContext context) => Builder(builder: (context) {
        if (_allFetched && _bookmarkList.isEmpty) {
          return const Center(
            child: Text('Noch keine Lesezeichen vorhanden'),
          );
        }
        return ListView.builder(
            // if there are still bookmarks, add a loader at the end of the list (+1 item)
            itemCount: _bookmarkList.length + (_allFetched ? 0 : 1),
            itemBuilder: (context, index) {
              if (index == _bookmarkList.length) {
                // deffer the loading of more bookmarks to the next frame,
                // so it does not get called during build
                Future.delayed(Duration.zero, () async {
                  logger.t('fetching more bookmarks');
                  _bookmarkProvider.getBookmarks();
                });
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
              return InkWell(
                onTap: () {
                  _singleJobProvider.getJob(bookmark.jobHashId).then((value) {
                    setState(() {
                      _job = value;
                    });
                    int colorIndex = Random().nextInt(10);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Dialog.fullscreen(
                                backgroundColor: Colors.transparent,
                                child: FlipCard(
                                  direction: FlipDirection.VERTICAL,
                                  front: Stack(
                                    children: [
                                      FrontCard(
                                          job: _job!,
                                          accentColor: PastelColorProvider()
                                              .generatePastelColor(colorIndex)
                                      ),
                                      FloatingActionButton(
                                        onPressed: () => {
                                          Navigator.pop(context)
                                        },
                                        child: const Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                  back: BackCard(
                                      job: _job!,
                                      accentColor: PastelColorProvider()
                                          .generatePastelColor(colorIndex)),
                                ),
                              ),
                            ));
                  });
                },
                child: Dismissible(
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
                    horizontalTitleGap: 4,
                    minVerticalPadding: 8,
                    tileColor: bookmark.isLiked ? Colors.green[50] : null,
                    title: Text(
                      bookmark.title ?? 'kein Titel verfügbar',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bookmark.employer),
                        SizedBox(
                          width: double.infinity,
                          child: Builder(builder: (context) {
                            if (bookmark.swipedJobInfo == null) {
                              return const SizedBox(
                                key: ValueKey('Loader'),
                                width: 25,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else {
                              return IconTheme(
                                data: const IconThemeData(color: Colors.grey),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      const Icon(Icons.remove_red_eye_outlined),
                                      const SizedBox(width: 4),
                                      SizedBox(
                                          width: 40,
                                          child: Text(_formatNumber(
                                              bookmark.swipedJobInfo!.views)))
                                    ]),
                                    Row(children: [
                                      const Icon(Icons.pageview_outlined),
                                      const SizedBox(width: 4),
                                      SizedBox(
                                          width: 40,
                                          child: Text(_formatNumber(
                                              bookmark.swipedJobInfo!.details)))
                                    ]),
                                    Row(children: [
                                      const Icon(Icons.bookmarks_outlined),
                                      const SizedBox(width: 4),
                                      SizedBox(
                                          width: 40,
                                          child: Text(_formatNumber(bookmark
                                              .swipedJobInfo!.bookmarks)))
                                    ]),
                                  ],
                                ),
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                    leading: IconButton(
                      icon: Icon(
                          bookmark.isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.green),
                      onPressed: () {
                        _bookmarkProvider.toggleBookmarkLike(bookmark);
                      },
                    ),
                    visualDensity: VisualDensity.comfortable,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    // trailing SwipedJobInfo
                  ),
                  confirmDismiss: (DismissDirection direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      _bookmarkProvider.toggleBookmarkLike(bookmark);
                      return false;
                    } else if (bookmark.isLiked) {
                      return await showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              DeleteBookmarkDialog(bookmark: bookmark));
                    } else {
                      return true;
                    }
                  },
                  onDismissed: (direction) {
                    _bookmarkProvider.removeBookmark(bookmark);
                  },
                ),
              );
            });
      });
}
