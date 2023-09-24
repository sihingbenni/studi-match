
import 'package:flutter/material.dart';
import 'package:studi_match/models/employment_agency/job_search_response.dart';
import 'package:studi_match/models/employment_agency/query_parameters.dart';
import 'package:studi_match/models/job.dart';
import 'package:studi_match/services/employment_agency/job_search_service.dart';
import 'package:studi_match/utilities/logger.dart';

class EAJobProvider extends ChangeNotifier {

  final _service = EAJobSearchService();

  bool isLoading = false;

  final QueryParameters _queryParameters;
  late JobSearchResponse _jobSearchResponse;

  final List<Job> _jobs = [];
  List<Job> get jobs => _jobs;

  int page = 0;

  /// constructor
  EAJobProvider(this._queryParameters) {
    getJobs();
  }

  // TODO combine different QueryParameters
  Future<void> getJobs() async {
    isLoading = true;
    notifyListeners();

    _jobSearchResponse = await _service.callJobsApi(_queryParameters);

    _jobs.addAll(_jobSearchResponse.jobListings);

    isLoading = false;
    notifyListeners();
  }

  void refresh() {
    getJobs();
  }

  void notify(int index) {
    logger.t('index: $index Nr of Jobs: ${_jobs.length} Percentage: ${100 - (index / _jobs.length * 100).floor()}');
    int percentageOfRemainingJobs = 100 - (index / _jobs.length * 100).floor();
    if (percentageOfRemainingJobs < 40 && _jobs.length < _jobSearchResponse.maxNrOfResults) {
      // get the next page
      page++;
      getJobs();
    }
  }

}