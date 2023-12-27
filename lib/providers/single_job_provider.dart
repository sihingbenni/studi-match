import 'package:flutter/cupertino.dart';
import 'package:studi_match/models/job.dart';
import 'package:studi_match/models/job_details.dart';
import 'package:studi_match/services/employment_agency/job_details_service.dart';

class SingleJobProvider extends ChangeNotifier {
  final _eaJobDetailsService = EAJobDetailsService();

  late Job job;

  Future<Job> getJob(String jobHashId) async {
    JobDetails jobDetails = await _eaJobDetailsService.callJobsApi(jobHashId);
    return Job.fromJobDetails(jobDetails);
  }
}
