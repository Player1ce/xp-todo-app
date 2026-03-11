import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xp_todo_app/exceptions/document_not_found_exception.dart';
import 'package:xp_todo_app/exceptions/network_exception.dart';
import 'package:xp_todo_app/exceptions/permission_exception.dart';
import 'package:xp_todo_app/exceptions/unknown_exception.dart';

// lib/core/utils/firebase_error_handler.dart

Exception handleFirebaseException(FirebaseException e) {
  switch (e.code) {
    case 'not-found':
      return DocumentNotFoundException('Document not found: ${e.message}');
    case 'permission-denied':
      return PermissionException('Access denied: ${e.message}');
    case 'unavailable':
    case 'network-request-failed':
      return NetworkException('Network error: ${e.message}');
    default:
      return UnknownException('Unexpected error: ${e.message}');
  }
}
