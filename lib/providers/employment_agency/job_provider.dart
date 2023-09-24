
import 'package:flutter/material.dart';
import 'package:studi_match/models/employment_agency/query_parameters.dart';
import 'package:studi_match/models/job.dart';
import 'package:studi_match/services/employment_agency/job_search_service.dart';

class EAJobProvider extends ChangeNotifier {

  final _service = EAJobSearchService();
  bool isLoading = false;
  List<Job> _jobs = [];
  List<Job> get jobs => _jobs;

  // TODO: implement the getJobs method
  Future<void> getJobs(QueryParameters queryParameters) async {
    notifyListeners();
    final response = await _service.callJobsApi(queryParameters);

    _jobs = response.jobListings;

    notifyListeners();
  }


}