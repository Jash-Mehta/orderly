
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
  const BadRequestFailure([String detail = 'Invalid request.']) : super(detail);
}

final class UnauthorizedFailure extends NetworkAppFailure {
  const UnauthorizedFailure([String detail = 'Session expired. Please log in again.'])
      : super(detail);
}

final class NotFoundFailure extends NetworkAppFailure {
  const NotFoundFailure([String detail = 'The requested resource was not found.'])
      : super(detail);
}

final class UnexpectedAppFailure extends NetworkAppFailure {
  const UnexpectedAppFailure([String detail = 'An unexpected error occurred.'])
      : super(detail);
}