import 'package:flutter/cupertino.dart';

enum Difficulty {
  trivial,
  easy,
  normal,
  hard,
  extreme; // Difficulties ordered from easies to hardest so index can be used for comparison

  static const defaultValue =
      Difficulty.normal; // default to normal if there is an error

  // Serialize to Firestore
  String toStorage() {
    return name; // 'trivial', 'easy', etc.
  }

  // deserialize from string
  static Difficulty fromStorage(String? value) {
    if (value == null) {
      debugPrint(
        'Difficulty value is null in fromStorage, defaulting to normal',
      );
    }
    return Difficulty.values.byName(value ?? defaultValue.name);
  }

  String get displayName {
    return name[0].toUpperCase() + name.substring(1); // 'Trivial', 'Easy', etc.
  }

  int get difficultyRating => index + 1; // 1 for trivial, 2 for easy, etc.

  Color get color {
    switch (this) {
      case Difficulty.extreme:
        return CupertinoColors.systemRed;
      case Difficulty.hard:
        return CupertinoColors.systemOrange;
      case Difficulty.normal:
        return CupertinoColors.systemGreen;
      case Difficulty.easy:
        return CupertinoColors.systemYellow;
      case Difficulty.trivial:
        return CupertinoColors.systemBlue;
    }
  }

  // Deserialize from display name (e.g. "Trivial")
  static Difficulty fromDisplayName(String displayName) {
    return Difficulty.values.firstWhere(
      (d) => d.displayName == displayName,
      orElse: () {
        debugPrint(
          'Difficulty value is null in fromDisplayName, defaulting to normal',
        );
        return defaultValue;
      },
    );
  }

  // NOTE: difficulty ratings should not be used for lasting serialization
  //    since they are based on the enum index, which can change if the enum
  //    is modified. Use the string values instead. This function is only for
  //    temporary conversions within the app.
  static Difficulty fromDifficultyRating(int rating) {
    return Difficulty.values.firstWhere(
      (d) => d.difficultyRating == rating,
      orElse: () {
        debugPrint(
          'Difficulty value is null in fromDifficultyRating, defaulting to normal',
        );
        return defaultValue;
      },
    );
  }
}
