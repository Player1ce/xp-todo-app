class PermissionException implements Exception {
  final String message;

  PermissionException([this.message = "Action failed"]);

  @override
  String toString() {
    return "PermissionException: $message";
  }
}
