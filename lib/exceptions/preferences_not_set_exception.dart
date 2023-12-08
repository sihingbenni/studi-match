
class PreferencesNotSetException implements Exception {
  final String message;

  PreferencesNotSetException(this.message);

  @override
  String toString() => 'PreferencesNotSetException: $message';
}