import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_role.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.id,
    required super.name,
    required super.email,
    required super.isEmailVerified,
    super.picture,
    super.createdAt,
    super.role = UserRole.user,
  });

  /// Firestore: set() / update()
  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'picture': picture,
      'role': role.name,
      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
    };
  }

  factory UserModel.fromFirestoreMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      isEmailVerified: map['isEmailVerified'] ?? false,
      picture: map['picture'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.user,
      ),
    );
  }

  /// Firebase Auth: after signInWithProvider
  factory UserModel.fromFirebaseUser(fb.User user) => UserModel(
    id: user.uid,
    name: user.displayName ?? '',
    email: user.email ?? '',
    isEmailVerified: user.emailVerified,
    picture: user.photoURL,
    createdAt: DateTime.now(),
    role: UserRole.user,
  );

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    bool? isEmailVerified,
    String? picture,
    DateTime? createdAt,
    UserRole? role,
  }) => UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    picture: picture ?? this.picture,
    createdAt: createdAt ?? this.createdAt,
    role: role ?? this.role,
  );

  /// Local storage: SharedPreferences / Hive

  // For local JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'picture': picture,
      'role': role.name,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      isEmailVerified: map['isEmailVerified'] ?? false,
      picture: map['picture'],
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.user,
      ),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
