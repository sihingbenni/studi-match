class SwipedJobInfo {
  late int bookmarks;
  late int details;
  late int views;

  SwipedJobInfo(
      {required this.bookmarks, required this.details, required this.views});

  SwipedJobInfo.empty() : this(bookmarks: 0, details: 0, views: 0);

  SwipedJobInfo.fromJson(Map json) {
    bookmarks = json['bookmarks'] ?? 0;
    details = json['details'] ?? 0;
    views = json['views'] ?? 0;
  }
}
