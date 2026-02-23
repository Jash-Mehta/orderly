final class ApiEndpoints {
  ApiEndpoints._(); // prevents instantiation

  static const auth = _AuthEndpoints();
}

// ── Auth ───────────────────────────────────────────────────────────────────────

final class _AuthEndpoints {
  const _AuthEndpoints();

  String get login => '/users/login';
  String get logout => '/auth/logout';
  String get refresh => '/auth/refresh';
  String get register => '/auth/register';
  String get forgotPassword => '/auth/forgot-password';
  String get resetPassword => '/auth/reset-password';
}