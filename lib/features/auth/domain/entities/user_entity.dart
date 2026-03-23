import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String name;
  final String email;
  final bool isEmailVerified;
  final String? picture;
  final DateTime? createdAt;

  const UserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.isEmailVerified,
    this.picture,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, picture, createdAt];
}
