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
              'location': const GeoPoint(0, 0),   // TODO Get location
              'package': 'TODO Get package name', // TODO Get package name
            },
          });
    } catch (e) {
      logger.e(e);
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getUser(String uuid) async {
    logger.i('getUser: $uuid');
    try {
      return await _db.collection('users').doc(uuid).get();
    } catch (e) {
      logger.e(e);
    }
    return null;
  }
}