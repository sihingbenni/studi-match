import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/exceptions/package_missing_exception.dart';
import 'package:studi_match/exceptions/preferences_not_set_exception.dart';
import 'package:studi_match/exceptions/user_does_not_exists_exception.dart';
import 'package:studi_match/exceptions/user_not_logged_in_exception.dart';
import 'package:studi_match/models/job.dart';
import 'package:studi_match/models/job_list.dart';
import 'package:studi_match/providers/async_job_provider.dart';
import 'package:studi_match/providers/config_provider.dart';
import 'package:studi_match/providers/query_parameter_provider.dart';
import 'package:studi_match/services/firebase/job_service.dart';
import 'package:studi_match/services/firebase/user_service.dart';
import 'package:studi_match/utilities/logger.dart';

class JobProvider extends ChangeNotifier {
  bool isLoading = false;

  final Map<String, Job> _jobList = {};

  Map<String, Job> get jobList => _jobList;
  final Map<String, AsyncJobProvider> _asyncJobProviders = {};

  /// constructor
  JobProvider();

  Future<Exception?> init() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return UserNotLoggedInException('user is not yet logged in');
    }

    DocumentSnapshot<Map<String, dynamic>>? user = await UserService().getUser(uid);
    if (user == null) {
      return UserDoesNotExistsException('user does not exist');
    }


    if(!user.exists) {
      // the user is logging in for the first time
      return UserDoesNotExistsException('user does not exist');
    }

    String packageString;

    try {
      packageString = user['preferences']['package'];
    } on StateError catch (e) {
      return PreferencesNotSetException(e.message);
    }

    Map<String, List<String>>? package = ConfigProvider.resultPackages[packageString];

    if (package == null) {
      return PackageMissingException('package: "$packageString" does not exist');
    }

    final listOfKeywords = package['listOfKeywords'];

    for (String keyword in listOfKeywords!) {
      final queryParameters = QueryParameterProvider().getWithKeyword(keyword);
      _asyncJobProviders[keyword] = AsyncJobProvider(keyword, queryParameters, _addJobsToMap);
    }
    return null;
  }

  void _addJobsToMap(JobList list) {
    for (var job in list.jobs) {
      // check if the job already exists in the list
      if (jobList.containsKey(job.hashId)) {
        // if yes add the new keyword to the list of keywords
        jobList[job.hashId]!.foundByKeyword.add(list.foundByKeyword);
      } else {
        // if the job does not exist in the list, add it as well as the keyword to the job
        job.foundByKeyword.add(list.foundByKeyword);
        jobList[job.hashId] = job;
      }
      notifyListeners();
    }
  }

  void notify({required int newIndex, required Job removedJob, required List<String> keywords}) {
    logger.t(
        'Nr of Jobs in List: ${jobList.length} - Index: $newIndex - Remaining: ${jobList.length - newIndex}');
    logger.t('Swiped Job was had the keywords: $keywords');
    logger.d('notifying $keywords that the index has changed');

    // notify each matching asyncJobProvider that the index has changed
    for (var asyncJobProviderKeyword in keywords) {
      _asyncJobProviders[asyncJobProviderKeyword]?.notifyScrolled();
    }

    // add entry to the list of swiped jobs
    JobService().addViewedJob(removedJob);
  }
}
