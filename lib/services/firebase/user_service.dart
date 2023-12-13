import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studi_match/providers/config_provider.dart';
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
              'packages': ConfigProvider.resultPackages.keys.toList(),
              'distance': 25,
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

  Future<void> updatePreferences(String uuid, List<String> packages, String location, int distance) async {
    try {
      await _db
          .collection('users')
          .doc(uuid)
          .update({
            'preferences': {
              'packages': packages,
              'location': location,
              'distance': distance,
            },
          });
    } catch (e) {
      logger.e(e);
    }
  }
}
