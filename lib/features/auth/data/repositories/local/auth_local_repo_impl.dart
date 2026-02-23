import 'dart:convert';
import 'package:orderly/core/di/service_locator.dart';
import 'package:orderly/features/auth/data/models/auth_models.dart';
import 'package:orderly/features/auth/data/repositories/local/auth_local_repo.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_data';

  // ── Token ──────────────────────────────────────────────────────────────────

  @override
  Future<void> saveToken(String token) =>
      secureStorage.write(key: _tokenKey, value: token);

  @override
  Future<String?> getToken() => secureStorage.read(key: _tokenKey);

  @override
  Future<void> deleteToken() => secureStorage.delete(key: _tokenKey);

  // ── User ───────────────────────────────────────────────────────────────────

  @override
  Future<void> saveUser(UserModel user) async {
    // Use dart:convert — never hand-roll JSON serialization.
    final json = jsonEncode({
      'id': user.id,
      'email': user.email,
      'name': user.name,
    });
    await secureStorage.write(key: _userKey, value: json);
  }

  @override
  Future<UserModel?> getUser() async {
    final raw = await secureStorage.read(key: _userKey);
    if (raw == null) return null;

    final map = jsonDecode(raw) as Map<String, dynamic>;
    return UserModel(
      id: map['id'] as String,
      token: map['token'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
    );
  }

  @override
  Future<void> deleteUser() => secureStorage.delete(key: _userKey);

  // ── Helpers ────────────────────────────────────────────────────────────────

  @override
  Future<void> clearAll() async {
    // Run deletions concurrently — no ordering dependency.
    await Future.wait([
      deleteToken(),
      deleteUser(),
    ]);
  }
}