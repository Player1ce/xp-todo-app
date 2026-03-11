// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xp_todo_app/data/models/data_with_id.dart';
import 'package:xp_todo_app/util/language_code.dart';
import 'package:xp_todo_app/util/time_utils.dart';
import 'package:xp_todo_app/util/enums/user_role.dart';

import 'dart:convert';

/// Unified user profile model
/// Replaces Parent, Researcher, and User collections
class UserProfile {
  final String id;
  final UserRole role;

  // Contact info
  final String? email;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;

  // Auth state
  final bool emailVerified;
  final bool twoFactorEnabled;
  final DateTime? twoFactorEnabledAt;

  // Privacy & consent (required for all users)
  final bool acceptedPrivacyPolicy;
  final String? policyVersion;
  final DateTime? consentDate;

  // Notifications
  final bool notificationsEnabled;
  final bool nightlyNotificationsEnabled;
  final bool weeklyNotificationsEnabled;

  // Metadata
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.id,
    required this.role,
    this.email,
    this.name,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.emailVerified = false,
    this.twoFactorEnabled = false,
    this.twoFactorEnabledAt,
    this.acceptedPrivacyPolicy = false,
    this.policyVersion,
    this.consentDate,
    this.notificationsEnabled = true,
    this.nightlyNotificationsEnabled = true,
    this.weeklyNotificationsEnabled = true,
    this.createdAt,
    this.updatedAt,
  });

  // Helper getters
  bool get isBase => role == UserRole.base;
  bool get isManager => role == UserRole.manager;
  bool get isAdmin => role == UserRole.admin;
  // bool get isDemoUser => status == UserStatus.demo;
  // bool get isActive => status == UserStatus.active;
  // bool get isSuspended => status == UserStatus.suspended;

  String get fullName {
    if ((firstName == null || firstName!.isEmpty) &&
        (lastName == null || lastName!.isEmpty)) {
      return name ?? '';
    }
    if (firstName != null && lastName != null) {
      return '$firstName $lastName'.trim();
    }
    return (firstName ?? lastName ?? '').trim();
  }

  /// Check if user requires 2FA (required for ALL users)
  bool get requires2FA => !twoFactorEnabled;

  /// Check if user has 2FA enabled
  bool get has2FAEnabled => twoFactorEnabled;

  UserProfile copyWith({
    String? id,
    UserRole? role,
    String? email,
    String? name,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    bool? emailVerified,
    bool? twoFactorEnabled,
    DateTime? twoFactorEnabledAt,
    bool? acceptedPrivacyPolicy,
    String? policyVersion,
    DateTime? consentDate,
    bool? notificationsEnabled,
    bool? nightlyNotificationsEnabled,
    bool? weeklyNotificationsEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      role: role ?? this.role,
      email: email ?? this.email,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailVerified: emailVerified ?? this.emailVerified,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      twoFactorEnabledAt: twoFactorEnabledAt ?? this.twoFactorEnabledAt,
      acceptedPrivacyPolicy:
          acceptedPrivacyPolicy ?? this.acceptedPrivacyPolicy,
      policyVersion: policyVersion ?? this.policyVersion,
      consentDate: consentDate ?? this.consentDate,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      nightlyNotificationsEnabled:
          nightlyNotificationsEnabled ?? this.nightlyNotificationsEnabled,
      weeklyNotificationsEnabled:
          weeklyNotificationsEnabled ?? this.weeklyNotificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // TODO: this version introduces a modification where ID is stored in the map.
  //  This will need to be stripped at uplaod for firestore repos.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'role': role.toStorage(),
      'email': email,
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'emailVerified': emailVerified,
      'twoFactorEnabled': twoFactorEnabled,
      'twoFactorEnabledAt': twoFactorEnabledAt,
      'acceptedPrivacyPolicy': acceptedPrivacyPolicy,
      'policyVersion': policyVersion,
      'consentDate': consentDate,
      'notificationsEnabled': notificationsEnabled,
      'nightlyNotificationsEnabled': nightlyNotificationsEnabled,
      'weeklyNotificationsEnabled': weeklyNotificationsEnabled,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String? ?? '',
      role: UserRole.fromStorage(map['role'] as String?),
      email: map['email'] as String?,
      name: map['name'] as String?,
      firstName: map['firstName'] as String?,
      lastName: map['lastName'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      emailVerified: map['emailVerified'] as bool? ?? false,
      twoFactorEnabled: map['twoFactorEnabled'] as bool? ?? false,
      twoFactorEnabledAt: map['twoFactorEnabledAt'] != null
          ? convertToDateTime(map['twoFactorEnabledAt'])
          : null,
      acceptedPrivacyPolicy: map['acceptedPrivacyPolicy'] as bool? ?? false,
      policyVersion: map['policyVersion'] as String?,
      consentDate: map['consentDate'] != null
          ? convertToDateTime(map['consentDate'])
          : null,
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
      nightlyNotificationsEnabled:
          map['nightlyNotificationsEnabled'] as bool? ?? true,
      weeklyNotificationsEnabled:
          map['weeklyNotificationsEnabled'] as bool? ?? true,
      createdAt: map['createdAt'] != null
          ? convertToDateTime(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? convertToDateTime(map['updatedAt'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source) as Map<String, dynamic>);

  factory UserProfile.fromDataWithId(DataWithId source) {
    Map<String, dynamic> data = source.data;
    data['id'] = source.id;
    return UserProfile.fromMap(data);
  }

  static Map<String, dynamic> createUpdateMap({
    UserRole? role,
    String? email,
    String? name,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? institution,
    bool? emailVerified,
    bool? twoFactorEnabled,
    DateTime? twoFactorEnabledAt,
    bool? acceptedPrivacyPolicy,
    String? policyVersion,
    DateTime? consentDate,
    LanguageCode? preferredLanguage,
    bool? notificationsEnabled,
    bool? nightlyNotificationsEnabled,
    bool? weeklyNotificationsEnabled,
  }) {
    Map<String, dynamic> map = {'updatedAt': FieldValue.serverTimestamp()};

    if (role != null) map['role'] = role.name;
    if (email != null) map['email'] = email;
    if (name != null) map['name'] = name;
    if (firstName != null) map['firstName'] = firstName;
    if (lastName != null) map['lastName'] = lastName;
    if (phoneNumber != null) map['phoneNumber'] = phoneNumber;
    if (institution != null) map['institution'] = institution;
    if (emailVerified != null) map['emailVerified'] = emailVerified;
    if (twoFactorEnabled != null) map['twoFactorEnabled'] = twoFactorEnabled;
    if (twoFactorEnabledAt != null) {
      map['twoFactorEnabledAt'] = twoFactorEnabledAt;
    }
    if (acceptedPrivacyPolicy != null) {
      map['acceptedPrivacyPolicy'] = acceptedPrivacyPolicy;
    }
    if (policyVersion != null) map['policyVersion'] = policyVersion;
    if (consentDate != null) map['consentDate'] = consentDate;
    if (preferredLanguage != null) {
      map['preferredLanguage'] = preferredLanguage.name;
    }
    if (notificationsEnabled != null) {
      map['notificationsEnabled'] = notificationsEnabled;
    }
    if (nightlyNotificationsEnabled != null) {
      map['nightlyNotificationsEnabled'] = nightlyNotificationsEnabled;
    }
    if (weeklyNotificationsEnabled != null) {
      map['weeklyNotificationsEnabled'] = weeklyNotificationsEnabled;
    }

    return map;
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, role: ${role.name}, email: $email, name: $name, firstName: $firstName, lastName: $lastName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserProfile) return false;

    return other.id == id &&
        other.role == role &&
        other.email == email &&
        other.name == name &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.phoneNumber == phoneNumber &&
        other.emailVerified == emailVerified &&
        other.twoFactorEnabled == twoFactorEnabled &&
        other.acceptedPrivacyPolicy == acceptedPrivacyPolicy;
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    role,
    email,
    name,
    firstName,
    lastName,
    phoneNumber,
    emailVerified,
    twoFactorEnabled,
    acceptedPrivacyPolicy,
  ]);
}
