/// All route paths in one place.
/// `final class` prevents instantiation and extension.
final class AppRoutes {
  AppRoutes._();

  static const login = '/login';
  static const home = '/home';
  static const adminRegister = '/admin-register';
  static const cart = '/cart';
  static const payment = '/payment';

  /// Routes accessible without authentication.
  static const _publicRoutes = {login, adminRegister};

  static bool isPublic(String path) => _publicRoutes.contains(path);
}
