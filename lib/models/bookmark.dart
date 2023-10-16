class Bookmark {
  final String jobHashId;
  late final SwipedJobInfo? swipedJobInfo;
  final String title;
  final String employer;
  final bool isLiked;

  Bookmark(
      {required this.jobHashId,
      this.swipedJobInfo,
      required this.title,
      required this.employer,
      required this.isLiked});
}

class SwipedJobInfo {
  final int bookmarks;
  final int detailViews;
  final int views;

  SwipedJobInfo({required this.bookmarks, required this.detailViews, required this.views});
}
