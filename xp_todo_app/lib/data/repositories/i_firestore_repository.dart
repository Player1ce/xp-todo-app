// lib/core/repositories/base_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:xp_todo_app/data/models/i_firestore_model.dart';
import 'package:xp_todo_app/util/firebase_error_handing.dart';

abstract class IFirestoreRepository {
  final FirebaseFirestore firestore;
  final bool isDemo;
  final List<String> collectionElements;

  const IFirestoreRepository(
    this.firestore,
    this.isDemo,
    this.collectionElements,
  );

  String get serviceName;

  CollectionReference<Map<String, dynamic>> collectionRef(
    List<String> pathSegments,
  ) {
    assert(
      pathSegments.length.isOdd,
      'Collection path must have an odd number of segments: ${pathSegments.join('/')}',
    );
    return firestore.collection(pathSegments.join('/'));
  }

  // --- Shared CRUD Methods ----------------------------
  // TODO: implement time metadata on creation
  Future<void> createDocumentWithId(
    CollectionReference<Map<String, dynamic>> collection,
    String docId,
    IFirestoreModel model,
  ) async {
    try {
      final data = model.toFirestore();
      data['dateCreated'] = FieldValue.serverTimestamp();
      data['dateUpdated'] = FieldValue.serverTimestamp();
      debugPrint(
        "$serviceName: creating document with id: $docId in ${collection.path} with data: $data",
      );
      await collection.doc(docId).set(data);
    } on FirebaseException catch (e) {
      debugPrint(
        "$serviceName: error creating document ${collection.path}/$docId: $e",
      );
      throw handleFirebaseException(e);
    } on Exception catch (e) {
      debugPrint(
        "$serviceName: unexpected error creating document ${collection.path}/$docId: $e",
      );
      rethrow;
    }
  }

  Future<String> createDocument(
    CollectionReference<Map<String, dynamic>> collection,
    IFirestoreModel model,
  ) async {
    try {
      final data = model.toFirestore();
      data['dateCreated'] = FieldValue.serverTimestamp();
      data['dateUpdated'] = FieldValue.serverTimestamp();
      debugPrint(
        "$serviceName: creating document in ${collection.path} with data: $data",
      );
      return (await collection.add(data)).id;
    } on FirebaseException catch (e) {
      debugPrint(
        "$serviceName: error creating document ${collection.path}/unknownId: $e",
      );
      throw handleFirebaseException(e);
    } on Exception catch (e) {
      debugPrint(
        "$serviceName: unexpected error creating document ${collection.path}/unknownId: $e",
      );
      rethrow;
    }
  }

  Future<T?> getDocument<T extends IFirestoreModel>(
    CollectionReference<Map<String, dynamic>> collection,
    String docId,
    T Function(String, Map<String, dynamic>) fromFirestore,
  ) async {
    try {
      debugPrint(
        "$serviceName: getting document in ${collection.path} with id: $docId",
      );
      final doc = await collection.doc(docId).get();
      if (!doc.exists || doc.data() == null) return null;
      return fromFirestore(docId, doc.data()!);
    } on FirebaseException catch (e) {
      debugPrint(
        "$serviceName: error fetching document ${collection.path}/$docId: $e",
      );
      throw handleFirebaseException(e);
    } on Exception catch (e) {
      debugPrint(
        "$serviceName: unexpected error fetching document ${collection.path}/$docId: $e",
      );
      rethrow;
    }
  }

  Future<void> updateDocument(
    CollectionReference<Map<String, dynamic>> collection,
    String docId,
    Map<String, dynamic> updates,
  ) async {
    updates['dateUpdated'] = FieldValue.serverTimestamp();
    updates.remove('id');

    debugPrint(
      "$serviceName: updating document in ${collection.path} with id: $docId and updates: $updates",
    );
    try {
      await collection.doc(docId).update(updates);
    } on FirebaseException catch (e) {
      debugPrint(
        "$serviceName: error updating document ${collection.path}/$docId: $e",
      );
      throw handleFirebaseException(e);
    } on Exception catch (e) {
      debugPrint(
        "$serviceName: unexpected error updating document ${collection.path}/$docId: $e",
      );
      rethrow;
    }
  }

  Future<void> deleteDocument(
    CollectionReference<Map<String, dynamic>> collection,
    String docId,
  ) async {
    debugPrint(
      "$serviceName: deleting document in ${collection.path} with id: $docId",
    );
    try {
      await collection.doc(docId).delete();
    } on FirebaseException catch (e) {
      debugPrint(
        "$serviceName: error deleting document ${collection.path}/$docId: $e",
      );
      throw handleFirebaseException(e);
    } on Exception catch (e) {
      debugPrint(
        "$serviceName: unexpected error deleting document ${collection.path}/$docId: $e",
      );
      rethrow;
    }
  }

  Future<bool> documentExists(
    CollectionReference<Map<String, dynamic>> collection,
    String docId,
  ) async {
    debugPrint(
      "$serviceName: checking existance of document in ${collection.path} with id: $docId",
    );
    try {
      final doc = await collection.doc(docId).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      debugPrint(
        "$serviceName: error checking existence of document ${collection.path}/$docId: $e",
      );
      throw handleFirebaseException(e);
    }
  }

  // Shared batch helper — all repositories can use this
  Future<void> runBatch(void Function(WriteBatch batch) operations) {
    final batch = firestore.batch();
    operations(batch);
    return batch.commit();
  }

  // --- watch document operations -----------------------------------------------
  Stream<T?> watchDocument<T extends IFirestoreModel>(
    CollectionReference<Map<String, dynamic>> collection,
    String docId,
    T Function(String, Map<String, dynamic>) fromFirestore,
  ) {
    try {
      return collection.doc(docId).snapshots().map((doc) {
        if (!doc.exists || doc.data() == null) return null;
        return fromFirestore(docId, doc.data()!);
      });
    } on FirebaseException catch (e) {
      debugPrint(
        "$serviceName: error watching document ${collection.path}/$docId: $e",
      );
      throw handleFirebaseException(e);
    }
  }
}
