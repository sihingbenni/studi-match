import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studi_match/utilities/logger.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser(String uuid) async {
    try {
      await _db
          .collection('users')
          .doc(uuid)
          .set({
            'preferences': {
              'location': '',
              'packages': [],
            },
          });
    } catch (e) {
      logger.e(e);
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getUser(String uuid) async {
    try {
      return await _db.collection('users').doc(uuid).get();
    } catch (e) {
      logger.e(e);
    }
    return null;
  }

  Future<void> updatePreferences(String uuid, List<String> packages, String location) async {
    try {
      await _db
          .collection('users')
          .doc(uuid)
          .update({
            'preferences': {
              'packages': packages,
              'location': location,
            },
          });
    } catch (e) {
      logger.e(e);
    }
  }
}
