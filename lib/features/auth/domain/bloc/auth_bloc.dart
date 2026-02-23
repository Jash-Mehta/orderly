import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:orderly/core/di/service_locator.dart';
import 'package:orderly/core/utils/methods/failure/app_failure.dart';
import 'package:orderly/core/api/api_result.dart';
import 'package:orderly/features/auth/data/models/user_models.dart';
import 'package:orderly/features/auth/data/models/auth_request.dart';
import 'package:orderly/features/auth/domain/bloc/auth_failure.dart';


part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.login(
      LoginRequest(email: event.email, password: event.password),
    );

    switch (result) {
      case Success(:final value):
        emit(AuthAuthenticated(user: value));
        
        talker.info('User authenticated: ${value.email}');
      case Failure(:final failure):
        emit(AuthFailureState(failure: failure));
        talker.error('Login failed: ${failure.message}');
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await authRepository.logout();

    // Always navigate to unauthenticated regardless of remote failure.
    // A cache failure is logged but the user is still logged out locally.
    switch (result) {
      case Success():
        emit(const AuthUnauthenticated());
        talker.info('Logout successful');
      case Failure(:final failure):
        emit(const AuthUnauthenticated());
        talker.warning('Logout had a non-critical error: ${failure.message}');
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    // Step 1 — check if a token exists locally
    final loggedInResult = await authRepository.isLoggedIn();

    switch (loggedInResult) {
      case Failure(:final failure):
        emit(AuthFailureState(failure: failure));
        return;
      case Success(:final value) when !value:
        emit(const AuthUnauthenticated());
        return;
      case Success():
        break; // token exists — proceed to restore user
    }

    // Step 2 — restore the user object from local storage
    final userResult = await authRepository.getCurrentUser();

    switch (userResult) {
      case Success(:final value) when value != null:
        emit(AuthAuthenticated(user: value));
        talker.info('Session restored: ${value.email}');
      case Success():
        // Token existed but user data was missing — session is corrupt
        emit(AuthFailureState(failure: const SessionExpiredFailure()));
      case Failure(:final failure):
        emit(AuthFailureState(failure: failure));
    }
  }
}