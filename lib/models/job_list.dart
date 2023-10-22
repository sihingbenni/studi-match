import 'package:studi_match/models/job.dart';

class JobList {
  final String foundByKeyword;
  final List<Job> jobs;

  JobList({required this.foundByKeyword, required this.jobs});
}