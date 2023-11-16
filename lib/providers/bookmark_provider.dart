

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/models/bookmark.dart';
import 'package:studi_match/models/job.dart';
import 'package:studi_match/providers/config_provider.dart';
import 'package:studi_match/services/firebase/bookmark_service.dart';
import 'package:studi_match/services/firebase/job_service.dart';
import 'package:studi_match/utilities/logger.dart';

class BookmarkProvider extends ChangeNotifier {

  final FirebaseAuth auth = FirebaseAuth.instance;
  late final String uuid;

  bool _isLoading = false;
  bool allFetched = false;

  DocumentSnapshot? _lastDocument;


  final _service = BookmarkService();
  final _jobService = JobService();

  final List<Bookmark> bookmarkList = [];

  /// constructor
  BookmarkProvider() {
    // The JobProvider has been created,
    // get the list of bookmarked jobs from the database by providing the uuid

    // in our current workflow, the user is always logged in!
    final User user = auth.currentUser!;
    uuid = user.uid;
  }

  void getBookmarks() {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    notifyListeners();

    _service.getBookmarks(uuid, _lastDocument).then((pair) {
      logger.t('adding ${pair.first.length} bookmarks to the list');

      bookmarkList.addAll(pair.first);
      // set the last document
      _lastDocument = pair.last;

      // check if all bookmarks have been fetched
      if (pair.first.length < ConfigProvider.bookmarkPageSize) {
        allFetched = true;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  void removeBookmark(int index) {
    _service.removeBookmark(uuid, bookmarkList[index].jobHashId);
    bookmarkList.removeAt(index);
    notifyListeners();
  }

  void addBookmark(Job job) {
    _service.addBookmark(uuid, job);
    _jobService.incrementBookmarkViews(job.hashId);
    notifyListeners();
  }
}