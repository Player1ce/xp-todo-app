import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // kIsWeb

Future<void> _configureFirestoreCache() async {
  const cacheSizeBytes = 250 * 1024 * 1024; // 150 MB
  final firestore = FirebaseFirestore.instance;

  if (kIsWeb) {
    // Web can fail in some environments (incognito, restricted storage, etc.).
    try {
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: cacheSizeBytes,
      );
    } catch (e, st) {
      developer.log(
        'Firestore web persistence unavailable; continuing without offline persistence.',
        error: e,
        stackTrace: st,
      );
    }

    firestore.settings = const Settings(cacheSizeBytes: cacheSizeBytes);
    return;
  }

  // Mobile/desktop
  firestore.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: cacheSizeBytes,
  );
}
