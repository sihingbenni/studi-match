
import 'package:studi_match/models/job.dart';

class JobListItem {
  late final String keyword;
  late final String hashId;
  final Job job;

  JobListItem({required this.job}) {
    hashId = job.hashId;
  }

  factory JobListItem.fromJobListItem(JobListItem jobListItem, keyword) {
    jobListItem.keyword = keyword;
    return jobListItem;
  }
}
