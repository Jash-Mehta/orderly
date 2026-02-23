import 'package:orderly/features/auth/data/models/auth_models.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();

  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> deleteUser();

  /// Clears all auth-related data from secure storage.
  Future<void> clearAll();
}