class JobFavorite {
  final String title;
  final String description;
  final bool isLiked;

  JobFavorite({
    required this.title,
    required this.description,
    this.isLiked = false,
  });
}
