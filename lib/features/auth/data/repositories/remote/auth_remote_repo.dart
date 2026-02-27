import 'package:orderly/features/auth/data/models/user_models.dart';
import 'package:orderly/features/auth/data/models/auth_request.dart';

abstract interface class AuthRepoRemote {
  /// Sends login credentials to the server.
  /// Throws [DioException] on network/server errors.
  Future<UserModel> login(LoginRequest request);

  /// Invalidates the session token on the server.
  /// Throws [DioException] on failure.
  Future<void> logout();
}