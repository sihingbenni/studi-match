
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

  /// constructor
  EAJobProvider(this._queryParameters) {
    _queryParameters.jobDescription = 'Werkstudent';
    _queryParameters.where = 'Kiel';
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
    logger.t('Nr of Jobs in List: ${_jobs.length} - Index: $index');
    int nrOfRemainingJobs = jobs.length - index;
    if (!isLoading && nrOfRemainingJobs < 10 && jobs.length < _jobSearchResponse.maxNrOfResults) {
      // get the next page
      _queryParameters.page++;
      getJobs();
    }
  }

}