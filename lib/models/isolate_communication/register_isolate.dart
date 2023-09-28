
import 'dart:isolate';

class RegisteredIsolate {
  final SendPort sendPort;

  RegisteredIsolate(this.sendPort);
}