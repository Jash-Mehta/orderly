import 'package:equatable/equatable.dart';
import 'package:orderly/core/utils/methods/map.dart';
class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String token;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    this.createdAt,
  });

  // ── Serialization ──────────────────────────────────────────────────────────

  factory UserModel.fromJson(Map<String, dynamic> map) {
    final user = (map['data'] as Map<String, dynamic>)['user'] as Map<String, dynamic>;
    return UserModel(
      id: user.getString('id'),
      email: user.getString('email'),
      name: user.getString('name'),
      token: user.getString('token'),
      createdAt: DateTime.tryParse(map.getString('createdAt'))?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  // ── Mutation ───────────────────────────────────────────────────────────────

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ── Equatable ──────────────────────────────────────────────────────────────

  @override
  List<Object?> get props => [id, email, name, createdAt, token];

  @override
  String toString() => 'User(id: $id, email: $email, name: $name)';
}