mixin FirestoreSerializableEnum on Enum {
  // Serialize to Firestore
  String toStorage() {
    return name; // 'trivial', 'easy', etc.
  }

  String get displayName {
    return name[0].toUpperCase() + name.substring(1); // 'Trivial', 'Easy', etc.
  }

}
