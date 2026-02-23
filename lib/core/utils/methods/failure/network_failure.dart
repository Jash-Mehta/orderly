

import 'package:orderly/core/utils/methods/failure/app_failure.dart';

sealed class NetworkAppFailure extends AppFailure {
  const NetworkAppFailure(super.message);
}

final class NoInternetFailure extends NetworkAppFailure {
  const NoInternetFailure()
      : super('No internet connection. Please check your network.');
}

final class TimeoutAppFailure extends NetworkAppFailure {
  const TimeoutAppFailure() : super('Request timed out. Please try again.');
}

final class ServerAppFailure extends NetworkAppFailure {
  const ServerAppFailure([String detail = 'Server error. Please try again later.'])
      : super(detail);
}

final class BadRequestFailure extends NetworkAppFailure {
  const BadRequestFailure() : super('Invalid request. Please check your input.');
}

final class UnauthorizedFailure extends NetworkAppFailure {
  const UnauthorizedFailure() : super('Session expired. Please log in again.');
}

final class NotFoundFailure extends NetworkAppFailure {
  const NotFoundFailure() : super('The requested resource was not found.');
}

final class UnexpectedAppFailure extends NetworkAppFailure {
  const UnexpectedAppFailure([String detail = 'An unexpected error occurred.'])
      : super(detail);
}