import 'dart:convert';

abstract class IFirestoreModel {
  // Metadata
  final DateTime? createdAt;
  final DateTime? updatedAt;

  IFirestoreModel({this.createdAt, this.updatedAt});

  Map<String, dynamic> toMap() {
    return {'createdAt': createdAt, 'updatedAt': updatedAt};
  }

  Map<String, dynamic> toFirestore() {
    return toMap().remove('id'); // Remove 'id' for Firestore storage
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'IFirestoreModel(createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IFirestoreModel &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => super.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
}
