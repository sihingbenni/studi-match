class GeoLocatorException implements Exception {
  final String message;

  GeoLocatorException(this.message);

  @override
  String toString() => 'GeoLocatorException: $message';
}
