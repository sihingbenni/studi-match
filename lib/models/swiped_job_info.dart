class SwipedJobInfo {
  late int bookmarks;
  late int detailViews;
  late int views;

  SwipedJobInfo({required this.bookmarks, required this.detailViews, required this.views});
  SwipedJobInfo.empty() : this(bookmarks: 0, detailViews: 0, views: 0);

  SwipedJobInfo.fromJson(Map json) {
    bookmarks = json['bookmarks'] ?? 0;
    detailViews = json['detailViews'] ?? 0;
    views = json['views'] ?? 0;
  }
}