import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xp_todo_app/data/repositories/firestore_repository.dart';

part 'firestore_providers.g.dart';

@riverpod
FirebaseFirestore firestore(Ref ref) {
  return FirebaseFirestore.instance;
}

@riverpod
FirestoreRepository firestoreRepository(Ref ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirestoreRepository(firestoreInstance: firestore);
}
