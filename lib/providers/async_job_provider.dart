import 'package:studi_match/models/job_list.dart';
import 'package:studi_match/models/query_parameters.dart';
import 'package:studi_match/services/employment_agency/job_search_service.dart';
import 'package:studi_match/utilities/logger.dart';

class AsyncJobProvider {
  final QueryParameters _queryParameters;
  void Function(JobList) addToList;
  final String _keyword;

  bool isLoading = false;


  final _service = EAJobSearchService();

  int _page = 1;

  int _displayedJobs = 0;
  int _nrOfFetchedJobs = 0;

  late int _maxNumberOfJobs;

  AsyncJobProvider(this._keyword, this._queryParameters, this.addToList) {
    getJobs();
  }

  void getJobs() {
    logger.d('fetching Jobs for the keyword: $_keyword');
    isLoading = true;
    _service
        .callJobsApi(_queryParameters)
        .then((jobSearchResponse) {
          addToList(JobList(foundByKeyword: _keyword, jobs: jobSearchResponse.jobListings));
          // overwrite the max number of Jobs, maybe one has been added
          _maxNumberOfJobs = jobSearchResponse.maxNrOfResults;
          // add the number of fetched jobs to the total of fetchedJobs
          _nrOfFetchedJobs += jobSearchResponse.jobListings.length;
          isLoading = false;
        });
  }

  void notifyScrolled() {
    _displayedJobs++;
    if (_nrOfFetchedJobs < _maxNumberOfJobs && _nrOfFetchedJobs - _displayedJobs < 10) {
      // increment page and update the queryParams
      _queryParameters.page = ++_page;
      getJobs();
    }
  }
}
