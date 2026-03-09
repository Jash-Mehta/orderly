

// ignore_for_file: unintended_html_in_doc_comment

import 'package:orderly/core/utils/methods/failure/app_failure.dart';

/// A generic Result type for the entire app.
/// 
/// Usage:
///   Future<Result<User>>         — success is User
///   Future<Result<List<Order>>>  — success is a list
///   Future<Result<void>>         — success has no value (void operations)
///   Future<Result<bool>>         — success is a boolean
///
/// Pattern match exhaustively:
///   switch (result) {
///     case Success(:final value) => ...
///     case Failure(:final failure) => ...
///   }
sealed class Result<T> {
  const Result();

  // ── Transformation ─────────────────────────────────────────────────────────

  /// Transforms the success value. Failures pass through unchanged.
  ///
  /// Example:
  ///   final Result<String> name = result.map((user) => user.name);
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
        Success(:final value) => Success(transform(value)),
        Failure(:final failure) => Failure(failure),
      };

  /// Chains another Result-returning operation on success.
  /// Short-circuits on failure — the second call is never made.
  ///
  /// Example:
  ///   final result = await loginResult.flatMap(
  ///     (response) => validateSession(response.token),
  ///   );
  Future<Result<R>> flatMap<R>(
    Future<Result<R>> Function(T value) transform,
  ) =>
      switch (this) {
        Success(:final value) => transform(value),
        Failure(:final failure) => Future.value(Failure(failure)),
      };

  // ── Unwrapping ─────────────────────────────────────────────────────────────

  /// Returns the value on success, or null on failure.
  T? getOrNull() => switch (this) {
        Success(:final value) => value,
        Failure() => null,
      };

  /// Returns the value on success, or [fallback] on failure.
  T getOrElse(T fallback) => switch (this) {
        Success(:final value) => value,
        Failure() => fallback,
      };

  /// Returns the value on success, or computes a fallback from the failure.
  ///
  /// Example:
  ///   final user = result.getOrElseMap((f) => User.guest(f.message));
  T getOrElseMap(T Function(AppFailure failure) fallback) => switch (this) {
        Success(:final value) => value,
        Failure(:final failure) => fallback(failure),
      };

  // ── Side effects ───────────────────────────────────────────────────────────

  /// Runs [onSuccess] or [onFailure] without transforming the result.
  /// Returns itself so you can chain further.
  ///
  /// Example:
  ///   await repo.login(request)
  ///     ..on(
  ///       onSuccess: (r) => talker.info('ok'),
  ///       onFailure: (f) => talker.error(f.message),
  ///     );
  Result<T> on({
    void Function(T value)? onSuccess,
    void Function(AppFailure failure)? onFailure,
  }) {
    switch (this) {
      case Success(:final value):
        onSuccess?.call(value);
      case Failure(:final failure):
        onFailure?.call(failure);
    }
    return this;
  }

  // ── Guards ─────────────────────────────────────────────────────────────────

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
}

// ── Variants ───────────────────────────────────────────────────────────────────

final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);

  @override
  String toString() => 'Success($value)';
}

final class Failure<T> extends Result<T> {
  final AppFailure failure;
  const Failure(this.failure);

  @override
  String toString() => 'Failure(${failure.message})';
}