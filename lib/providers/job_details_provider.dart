import 'package:flutter/material.dart';
import 'package:studi_match/models/job.dart';
import 'package:studi_match/models/job_details.dart';
import 'package:studi_match/services/employment_agency/job_details_service.dart';

class JobDetailsProvider extends ChangeNotifier {

  late JobDetails? jobDetails;
  late Job? job;

  void getDetails(Job job) async {
    this.job = job;
    EAJobDetailsService jobDetailsService = EAJobDetailsService();
    jobDetails = await jobDetailsService.callJobsApi(job.hashId);
    job.jobDetails = jobDetails;
    notifyListeners();
  }
}
