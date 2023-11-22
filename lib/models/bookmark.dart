import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studi_match/models/swiped_job_info.dart';

class Bookmark {
  final String jobHashId;
  SwipedJobInfo? swipedJobInfo;
  final String? title;
  final String employer;
  bool isLiked;
  final Stream<DocumentSnapshot<Object?>> jobReferenceStream;

  Bookmark(
      {required this.jobHashId,
      this.swipedJobInfo,
      required this.title,
      required this.employer,
      required this.isLiked,
      required this.jobReferenceStream});
}
