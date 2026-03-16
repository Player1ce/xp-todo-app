abstract class IFirestoreModel {
  Map<String, dynamic> toMap();

  Map<String, dynamic> toFirestore() {
    return toMap().remove('id'); // Remove 'id' for Firestore storage
  }
}
