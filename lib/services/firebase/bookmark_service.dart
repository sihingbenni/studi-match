import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studi_match/models/bookmark.dart';
import 'package:studi_match/models/job.dart';
import 'package:studi_match/services/firebase/user_service.dart';
import 'package:studi_match/utilities/logger.dart';

class BookmarkService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Bookmark>> getBookmarks(String uuid) async {
    List<Bookmark> bookmarkList = [];
    try {
      var userDocument = await _db.collection('users').doc(uuid).get();

      if (!userDocument.exists) {
        // user does not exist, create new
        await UserService().addUser(uuid);
        // the user just got created, he has no bookmarks
        return [];
      }

      final QuerySnapshot result =
          await _db.collection('users').doc(uuid).collection('bookmarks').get();
      final List<DocumentSnapshot> documents = result.docs;
      for (var element in documents) {
        logger.i(element['isLiked']);
        final jobReference = await element['job_reference'].get();
        bookmarkList.add(Bookmark(
            title: jobReference['job_info']['title'],
            employer: jobReference['job_info']['employer'],
            jobHashId: element.id,
            isLiked: element['isLiked']));
      }
    } catch (e) {
      logger.e(e);
    }
    return bookmarkList;
  }

  Future<void> addBookmark(String uuid, Job job) async {
    try {
      DocumentReference jobReference =
          FirebaseFirestore.instance.collection('jobs').doc(job.hashId);

      await _db
          .collection('users')
          .doc(uuid)
          .collection('bookmarks')
          .doc(job.hashId)
          .set({
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
  }
}
