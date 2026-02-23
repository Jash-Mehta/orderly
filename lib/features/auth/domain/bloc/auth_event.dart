part of 'auth_bloc.dart';

/// Sealed class guarantees compile-time exhaustiveness —
/// forget a case in a switch and the compiler warns you.
sealed class AuthEvent {
  const AuthEvent();
}

final class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });
}

final class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}