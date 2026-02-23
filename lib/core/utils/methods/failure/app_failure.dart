/// Base class for all domain failures across the app.
/// Every feature defines its own sealed subclass of [AppFailure].
abstract class AppFailure {
  final String message;
  const AppFailure(this.message);

  @override
  String toString() => '$runtimeType(message: $message)';
}