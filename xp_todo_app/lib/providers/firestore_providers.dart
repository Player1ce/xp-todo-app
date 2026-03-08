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
FirestoreRepository userRepository(Ref ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirestoreRepository(firestore);
} 

// @riverpod
// Stream<T> firestoreDocument<T>(Ref ref, String path) {
//   return FirebaseFirestore.instance.doc(path).snapshots().map((doc) {
//     if (!doc.exists || doc.data() == null) return null;
//     return T.fromMap(doc.data()!);
//   });
// }

// // Concrete providers per type (generator-friendly)
// @riverpod
// Future<Quest> guestItem(QuestItemRef ref, String id) =>
//     fetchById<User>(id, User.fromJson);

// @riverpod
// Future<Product> productItem(ProductItemRef ref, String id) =>
//     fetchById<Product>(id, Product.fromJson);

// // Shared generic logic lives here, not in the provider itself
// Future<T> fetchById<T>(
//   String id,
//   T Function(Map<String, dynamic>) fromJson,
// ) async {
//   final data = await someApi.fetch(id);
//   return fromJson(data);
// }
