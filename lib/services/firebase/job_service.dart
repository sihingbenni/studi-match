import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studi_match/models/job.dart';
import 'package:studi_match/utilities/logger.dart';

class JobService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addViewedJob(Job job) async {
    try {
      await _db.collection('jobs').doc(job.hashId).set({
        'job_info': {'title': job.title, 'employer': job.employer},
        'swipe_info': {
          'views': FieldValue.increment(1),
        }
      }, SetOptions(merge: true));
    } catch (e) {
      logger.e(e);
    }
  }

  void incrementBookmarkViews(String hashId) {
    _db.collection('jobs').doc(hashId).update({
      'swipe_info.bookmarks': FieldValue.increment(1),
    });
  }

  void incrementDetailViews(String hashId) {
    _db.collection('jobs').doc(hashId).update({
      'swipe_info.details': FieldValue.increment(1),
    });
  }
}
