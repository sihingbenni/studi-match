import 'package:studi_match/models/job_list.dart';
import 'package:studi_match/models/query_parameters.dart';
import 'package:studi_match/services/employment_agency/job_search_service.dart';
import 'package:studi_match/utilities/logger.dart';

/// This class is responsible for fetching the jobs from the api.
/// You need to provide a callback function where the fetched jobs are being deposited.
class AsyncJobProvider {

  final String _keyword;
  final QueryParameters _queryParameters;
  /// callback function where the fetched jobs are being deposited
  void Function(JobList) addToList;


  final _service = EAJobSearchService();

  bool isLoading = false;

  /// page counter for the queryParameters
  int _page = 1;

  /// counter for the number of displayed jobs
  int _displayedJobs = 0;
  /// counter for the number of fetched jobs
  int _nrOfFetchedJobs = 0;

  /// Number of the maximum number of jobs that can be fetched.
  /// The value is set the first time the api is called.
  late int _maxNumberOfJobs;

  /// constructor
  AsyncJobProvider(this._keyword, this._queryParameters, this.addToList) {
    // fetches the first set of jobs on initialization
    getJobs();
  }

  void getJobs() {
    logger.d('fetching Jobs for the keyword: $_keyword');
    isLoading = true;
    _service.callJobsApi(_queryParameters).then((jobSearchResponse) {
      addToList(JobList(foundByKeyword: _keyword, jobs: jobSearchResponse.jobListings));
      // overwrite the max number of Jobs, maybe one has been added
      _maxNumberOfJobs = jobSearchResponse.maxNrOfResults;
      // add the number of fetched jobs to the total of fetchedJobs
      _nrOfFetchedJobs += jobSearchResponse.jobListings.length;
      logger.d('keyword: $_keyword - fetched $_nrOfFetchedJobs Jobs');
      isLoading = false;
    });
  }

  /// Increments the number of displayed jobs.
  /// Checks if there are still jobs to fetch.
  /// If there are less than 10 jobs left to fetch, fetch the next page.
  void notifyScrolled() {
    _displayedJobs++;
    if (_nrOfFetchedJobs < _maxNumberOfJobs && _nrOfFetchedJobs - _displayedJobs < 10) {
      // increment page and update the queryParams
      _queryParameters.page = ++_page;
      getJobs();
    }
  }
}
