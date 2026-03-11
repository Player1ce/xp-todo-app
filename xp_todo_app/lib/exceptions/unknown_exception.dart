class UnknownException implements Exception {
  final String message;

  UnknownException([this.message = "Action failed"]);

  @override
  String toString() {
    return "UnknownException: $message";
  }
}
