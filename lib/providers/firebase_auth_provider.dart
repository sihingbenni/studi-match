

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthProvider {

  static FirebaseAuth authInstance = FirebaseAuth.instance;

  /// overwrite the auth instance for testing purposes
  static overwriteAuthInstance(FirebaseAuth newAuthInstance) {
    authInstance = newAuthInstance;
  }

}