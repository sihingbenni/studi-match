

class IsolatedStreamResponse<T> {
  final String fromIsolateId;
  final T data;

  IsolatedStreamResponse(this.fromIsolateId, this.data);
}