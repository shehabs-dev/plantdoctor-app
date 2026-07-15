import 'package:equatable/equatable.dart';
import 'user_role.dart';

class UserEntity extends Equatable {
  final String? id;
  final String name;
  final String email;
  final bool isEmailVerified;
  final String? picture;
  final DateTime? createdAt;
  final UserRole role;

  const UserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.isEmailVerified,
    required this.role,
    this.picture,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, isEmailVerified, picture, createdAt, role];
}
