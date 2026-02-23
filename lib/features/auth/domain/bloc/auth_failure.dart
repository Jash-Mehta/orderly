import 'package:orderly/core/utils/methods/failure/app_failure.dart';

sealed class AuthFailure extends AppFailure {
  const AuthFailure(super.message);
}

final class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure() : super('Invalid email or password');
}

final class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure() : super('Your session has expired. Please log in again.');
}

final class CacheFailure extends AuthFailure {
  const CacheFailure([String detail = 'Local storage error.']) : super(detail);
}