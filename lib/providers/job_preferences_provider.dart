

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/services/firebase/user_service.dart';

class JobPreferencesProvider extends ChangeNotifier {
  List<String> packages = [];
  String location = '';
  int distance = 25;

  bool loading = true;

  Future<void> getPreferences(String uuid) async {

    DocumentSnapshot<Map<String, dynamic>>? user = await UserService().getUser(uuid);

    if (user == null) {
      return;
    }

    packages = List<String>.from(user['preferences']['packages'] as List);
    location = user['preferences']['location'];
    distance = user['preferences']['distance'];

    loading = false;
    notifyListeners();
  }

  void savePreferences(String uuid, List<String> packages, String location, int distance) {
    loading = true;
    this.packages = packages;
    this.location = location;
    this.distance = distance;
    UserService().updatePreferences(uuid, packages, location, distance);
    loading = false;
    notifyListeners();
  }
}