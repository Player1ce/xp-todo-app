import 'dart:convert';

abstract class IFirestoreModel {
  // Metadata
  final DateTime? dateCreated;
  final DateTime? dateUpdated;

  IFirestoreModel({this.dateCreated, this.dateUpdated});

  Map<String, dynamic> toMap() {
    return {'dateCreated': dateCreated, 'dateUpdated': dateUpdated};
  }

  Map<String, dynamic> toFirestore() {
    final map = toMap();
    map.remove('id'); // Remove 'id' for Firestore storage
    return map;
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'IFirestoreModel(dateCreated: $dateCreated, dateUpdated: $dateUpdated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IFirestoreModel &&
        other.dateCreated == dateCreated &&
        other.dateUpdated == dateUpdated;
  }

  @override
  int get hashCode =>
      super.hashCode ^ dateCreated.hashCode ^ dateUpdated.hashCode;
}
