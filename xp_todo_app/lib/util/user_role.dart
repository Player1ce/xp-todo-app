// note: lower numbers are higher authority roles
import 'package:flutter/foundation.dart';

enum UserRole {
  admin,
  manager,
  base,
  unauthenticated;

  int get priority {
    switch (this) {
      case UserRole.admin:
        return 0;
      case UserRole.manager:
        return 3;
      case UserRole.base:
        return 5;
      case UserRole.unauthenticated:
        return 100;
    }
  }

  static const defaultValue = UserRole
      .unauthenticated; // default to unauthenticated if there is an error

  // Serialize to Firestore
  String toStorage() {
    return name; // 'trivial', 'easy', etc.
  }

  // deserialize from string
  static UserRole fromStorage(String? value) {
    if (value == null) {
      debugPrint('UserRole value is null in fromStorage, defaulting to normal');
    }
    return UserRole.values.byName(value ?? defaultValue.name);
  }

  String get displayName {
    return name[0].toUpperCase() + name.substring(1); // 'Trivial', 'Easy', etc.
  }

  /// Check if this role can access data meant for target role
  bool canAccessData(UserRole targetRole) {
    return priority <= targetRole.priority;
  }

  static bool isAtLeast(UserRole role, UserRole targetRole) {
    return role.index <= targetRole.index;
  }

  static List<UserRole> getUserRolesFromClaims(Map<String, dynamic> claims) {
    List<UserRole> roles = [];

    if (claims[UserRole.admin.name] == true) {
      roles.add(UserRole.admin);
    }
    if (claims[UserRole.manager.name] == true) {
      roles.add(UserRole.manager);
    }
    if (claims[UserRole.base.name] == true) {
      roles.add(UserRole.base);
    }

    return roles;
  }
}
