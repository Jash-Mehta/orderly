final class ApiEndpoints {
  ApiEndpoints._(); // prevents instantiation

  static const auth = _AuthEndpoints();
  static const home = _HomeEndpoints();
  static const orders = _OrdersEndpoints();
  static const shipments = _ShipmentsEndpoints();
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

// ── Orders ───────────────────────────────────────────────────────────────────────

final class _OrdersEndpoints {
  const _OrdersEndpoints();
  String get createOrder => '/orders/with-items';
}

// ── Shipments ─────────────────────────────────────────────────────────────────────

final class _ShipmentsEndpoints {
  const _ShipmentsEndpoints();
  String tracking(String shipmentId) => '/api/shipment/$shipmentId/tracking';
}