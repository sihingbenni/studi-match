

class IsolatedStreamResponse<T> {
  final String fromIsolateId;
  final T data;

  IsolatedStreamResponse({required this.fromIsolateId, required this.data});
}