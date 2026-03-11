class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = "Action failed"]);

  @override
  String toString() {
    return "NetworkException: $message";
  }
}
