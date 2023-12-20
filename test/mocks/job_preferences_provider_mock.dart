

import 'dart:ui';

import 'package:studi_match/providers/job_preferences_provider.dart';

class JobPreferencesProviderMock implements JobPreferencesProvider {
  @override
  int distance;

  @override
  bool loading;

  @override
  String location;

  @override
  List<String> packages;

  JobPreferencesProviderMock({this.distance = 25, this.loading = false, this.location = '24114', this.packages = const []});

  @override
  Future<void> getPreferences(String uuid) => Future.value();

  @override
  bool get hasListeners => true;

  @override
  void savePreferences(String uuid, List<String> packages, String location, int distance) {
    return;
  }

  @override
  void addListener(VoidCallback listener) {
    return;
  }

  @override
  void dispose() {
    return;
  }

  @override
  void notifyListeners() {
    return;
  }

  @override
  void removeListener(VoidCallback listener) {
    return;
  }

}