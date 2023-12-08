
class UserDoesNotExistsException implements Exception {
  final String message;
  UserDoesNotExistsException(this.message);

  @override
  String toString() => 'UserDoesNotExistsException: $message';
}