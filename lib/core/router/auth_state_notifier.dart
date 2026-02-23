import 'dart:async';
import 'package:flutter/material.dart';
import 'package:orderly/core/di/service_locator.dart';
import 'package:orderly/features/auth/domain/bloc/auth_bloc.dart';

/// Bridges [AuthBloc] state changes to GoRouter's [refreshListenable].
/// GoRouter calls [redirect] every time this notifier fires.
class AuthStateNotifier extends ChangeNotifier {
  AuthStateNotifier() {
    _subscription = authBloc.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}