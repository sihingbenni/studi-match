

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/services/firebase/user_service.dart';

class JobPreferencesProvider extends ChangeNotifier {
  List<String> packages = [];
  String location = '';

  bool loading = true;

  Future<void> getPreferences(String uuid) async {

    DocumentSnapshot<Map<String, dynamic>>? user = await UserService().getUser(uuid);

    if (user == null) {
      return;
    }

    packages = List<String>.from(user['preferences']['packages'] as List);
    location = user['preferences']['location'];

    loading = false;
    notifyListeners();
  }

  void updateLocation(String uuid, location) {
    loading = true;
    this.location = location;
    UserService().updatePreferences(uuid, packages, location);
    loading = false;
    notifyListeners();
  }

  void updatePackages(String uuid, List<String> packages) {
    loading = true;
    this.packages = packages;
    UserService().updatePreferences(uuid, packages, location);
    loading = false;
    notifyListeners();
  }
}