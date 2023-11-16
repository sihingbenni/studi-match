import 'package:flutter/material.dart';
import 'package:studi_match/models/job_details.dart';
import 'package:studi_match/services/employment_agency/job_details_service.dart';
import 'package:studi_match/utilities/logger.dart';

class JobDetailsProvider extends ChangeNotifier {

  JobDetails? jobDetails;

  void getDetails(String jobHashId) async {
    EAJobDetailsService jobDetailsService = EAJobDetailsService();
    jobDetails = await jobDetailsService.callJobsApi(jobHashId);
    logger.f(jobDetails);
    notifyListeners();
  }
}
