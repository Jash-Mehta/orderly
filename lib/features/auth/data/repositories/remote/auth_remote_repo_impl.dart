
import 'package:orderly/constants/api_endpoints.dart';
import 'package:orderly/core/di/service_locator.dart';
import 'package:orderly/core/api/api_response.dart';
import 'package:orderly/core/api/api_result.dart';
import 'package:orderly/features/auth/data/models/user_models.dart';
import 'package:orderly/features/auth/data/models/auth_request.dart';
import 'package:orderly/features/auth/data/repositories/remote/auth_remote_repo.dart';

class AuthRepoRemoteeImpl implements AuthRepoRemote {
@override
Future<UserModel> login(LoginRequest request) async {
  final result = await apiClient.post(
    ApiEndpoints.auth.login,
    body: request.toJson(),
  );
  return switch (result) {
    Success(:final value) => () {
        talker.info('Raw login response: $value'); // 👈 add this
        return UserModel.fromJson(value);
      }(),
    Failure(:final failure) => throw failure,
  };
}
  @override
  Future<void> logout() async {
    
   // await dio.post<void>('/auth/logout');
  }
}