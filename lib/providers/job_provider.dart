import 'package:flutter/material.dart';
import 'package:studi_match/models/job.dart';
import 'package:studi_match/models/job_list.dart';
import 'package:studi_match/providers/async_job_provider.dart';
import 'package:studi_match/providers/config_provider.dart';
import 'package:studi_match/providers/query_parameter_provider.dart';
import 'package:studi_match/services/firebase/job_service.dart';
import 'package:studi_match/utilities/logger.dart';

class JobProvider extends ChangeNotifier {
  bool isLoading = false;

  final Map<String, Job> _jobList = {};

  Map<String, Job> get jobList => _jobList;
  final Map<String, AsyncJobProvider> _asyncJobProviders = {};

  /// constructor
  JobProvider() {
    // The JobProvider has been created,
    // now lets create one isolate for each query that needs to be done.
    final listOfKeywords = ConfigProvider.resultPackages['workingStudent']!['listOfKeywords'];

    for (String keyword in listOfKeywords!) {
      final queryParameters = QueryParameterProvider().getWithKeyword(keyword);
      _asyncJobProviders[keyword] = AsyncJobProvider(keyword, queryParameters, _addJobsToMap);
    }
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
    logger.t('Nr of Jobs in List: ${jobList.length} - Index: $newIndex - Remaining: ${jobList.length - newIndex}');
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
