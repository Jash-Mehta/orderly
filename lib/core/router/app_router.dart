

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly/core/di/service_locator.dart';
import 'package:orderly/core/router/auth_state_notifier.dart';
import 'package:orderly/core/router/app_routes.dart';
import 'package:orderly/features/auth/domain/bloc/auth_bloc.dart';
import 'package:orderly/features/auth/presentation/screens/login_screen.dart';
import 'package:orderly/features/home/presentation/screen/home_screen.dart';
import 'package:orderly/features/home/presentation/screen/cart_screen.dart';


class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.login,
    refreshListenable: AuthStateNotifier(),

    // ── Auth guard ──────────────────────────────────────────────────────────
    redirect: (context, state) {
      final authState = authBloc.state;
      final isPublicRoute = AppRoutes.isPublic(state.matchedLocation);

      // Still loading — don't redirect yet.
      if (authState is AuthLoading || authState is AuthInitial) return null;

      final isAuthenticated = authState is AuthAuthenticated;

      // Authenticated user trying to access login — send to home.
      if (isAuthenticated && isPublicRoute) return AppRoutes.home;

      // Unauthenticated user trying to access a protected route — send to login.
      if (!isAuthenticated && !isPublicRoute) return AppRoutes.login;

      return null; // no redirect needed
    },

    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child:  HomeScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.cart,
        name: 'cart',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const CartScreen(),
        ),
      ),
      // Add protected routes here as your app grows.
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.login),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    ),
  );
}

