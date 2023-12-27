class PackageMissingException implements Exception {
  final String message;

  PackageMissingException(this.message);

  @override
  String toString() => 'PackageMissingException: $message';
}
