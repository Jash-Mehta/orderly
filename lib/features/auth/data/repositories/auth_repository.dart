import 'package:orderly/core/utils/methods/api/api_result.dart';
import 'package:orderly/features/auth/data/models/auth_models.dart';
import 'package:orderly/features/auth/data/models/auth_request.dart';


abstract interface class AuthRepository {
  Future<Result<UserModel>> login(LoginRequest request);
  Future<Result<void>> logout();
  Future<Result<UserModel?>> getCurrentUser();
  Future<Result<bool>> isLoggedIn();
}