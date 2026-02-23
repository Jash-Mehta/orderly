final class ApiEndpoints {
  ApiEndpoints._(); // prevents instantiation

  static const auth = _AuthEndpoints();
  static const home = _HomeEndpoints();
}

// ── Auth ───────────────────────────────────────────────────────────────────────

final class _AuthEndpoints {
  const _AuthEndpoints();
  String get login => '/users/login';

}

// ── Home ───────────────────────────────────────────────────────────────────────

final class _HomeEndpoints {
  const _HomeEndpoints();
  String get home => '/inventory';

}