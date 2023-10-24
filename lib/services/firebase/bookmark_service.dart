import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studi_match/models/bookmark.dart';
import 'package:studi_match/models/job.dart';
import 'package:studi_match/models/pair.dart';
import 'package:studi_match/providers/config_provider.dart';
import 'package:studi_match/services/firebase/user_service.dart';
import 'package:studi_match/utilities/logger.dart';

class BookmarkService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getBookmarkStream(String uuid) {
    try {
      return _db.collection('users').doc(uuid).collection('bookmarks').snapshots();
    } catch (e) {
      logger.e(e);
      throw Exception(e);
    }
  }

  Future<Pair<List<Bookmark>, DocumentSnapshot?>> getBookmarks(
      String uuid, DocumentSnapshot? lastDocument) async {
    List<Bookmark> bookmarkList = [];
    Query query;

    try {
      var userDocument = await _db.collection('users').doc(uuid).get();

      if (!userDocument.exists) {
        // user does not exist, create new
        await UserService().addUser(uuid);
        // the user just got created, he has no bookmarks
        return Pair([], null);
      }

      // build the query
      if (lastDocument != null) {
        query = _db
            .collection('users')
            .doc(uuid)
            .collection('bookmarks')
            .limit(ConfigProvider.bookmarkPageSize)
            .startAfterDocument(lastDocument);
      } else {
        query = _db
            .collection('users')
            .doc(uuid)
            .collection('bookmarks')
            .limit(ConfigProvider.bookmarkPageSize);
      }

      // execute the query
      final QuerySnapshot result = await query.get();
      // get the bookmark documents
      final List<DocumentSnapshot> documents = result.docs;

      // if there are no documents, return an empty list
      if (documents.isEmpty) {
        return Pair([], null);
      }
      // for each bookmark document, get the job reference and add it to the list
      for (var doc in documents) {
        DocumentReference jobReferenceString = doc['job_reference'];
        final jobReference = await jobReferenceString.get();
        Stream<DocumentSnapshot<Object?>> jobReferenceStream = jobReferenceString.snapshots();
        Bookmark bookmark = Bookmark(
            jobHashId: doc.id,
            title: jobReference['job_info']['title'],
            employer: jobReference['job_info']['employer'],
            isLiked: doc['isLiked'],
            jobReferenceStream: jobReferenceStream);
        bookmarkList.add(bookmark);
      }
      return Pair(bookmarkList, documents.last);
    } catch (e) {
      logger.e(e);
      throw Exception(e);
    }
  }

  Future<void> addBookmark(String uuid, Job job) async {
    try {
      DocumentReference jobReference =
          FirebaseFirestore.instance.collection('jobs').doc(job.hashId);

      await _db.collection('users').doc(uuid).collection('bookmarks').doc(job.hashId).set({
        'job_reference': jobReference,
        'isLiked': false,
      });
      logger.i('Bookmark added');
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> removeBookmark(String uuid, String jobId) async {
    try {
      await _db.collection('users').doc(uuid).collection('bookmarks').doc(jobId).delete();
    } catch (e) {
      logger.e(e);
    }
    logger.i('Bookmark removed');
  }

  Future<void> toggleBookmarkLike(String uuid, Bookmark bookmark, bool toggle) async {
    try {
      await _db
          .collection('users')
          .doc(uuid)
          .collection('bookmarks')
          .doc(bookmark.jobHashId)
          .update({'isLiked': toggle});
    } catch (e) {
      logger.e(e);
    }
  }
}
