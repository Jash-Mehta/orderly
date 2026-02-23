import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:orderly/core/network/api_client.dart';
import 'package:orderly/core/network/dio_client.dart';
import 'package:orderly/features/auth/data/repositories/auth_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:orderly/features/auth/data/repositories/local/auth_local_repo.dart';
import 'package:orderly/features/auth/data/repositories/local/auth_local_repo_impl.dart';
import 'package:orderly/features/auth/data/repositories/remote/auth_remote_repo.dart';
import 'package:orderly/features/auth/data/repositories/remote/auth_remote_repo_impl.dart';
import 'package:orderly/features/auth/domain/bloc/auth_bloc.dart';
import 'package:orderly/features/auth/data/repositories/auth_repository_impl.dart';

final getIt = GetIt.instance;

// ── Global accessors ───────────────────────────────────────────────────────────
// Only expose what other parts of the app genuinely need to access globally.
// Internal data sources stay private to the repository layer.

Talker get talker => getIt<Talker>();
FlutterSecureStorage get secureStorage => getIt<FlutterSecureStorage>();
ApiClient get apiClient => getIt<ApiClient>();
Connectivity get connectivity => getIt<Connectivity>();
AuthRepository get authRepository => getIt<AuthRepository>();
AuthRemoteDataSource get authRemoteDataSource => getIt<AuthRemoteDataSource>();
AuthLocalDataSource get authLocalDataSource => getIt<AuthLocalDataSource>();
AuthBloc get authBloc => getIt<AuthBloc>();

// ── Registration ───────────────────────────────────────────────────────────────

Future<void> initServices(Talker talker) async {
  // ── Core ─────────────────────────────────────────────────────────────────
  // Register the talker instance created in initApp — single instance app-wide.
  getIt.registerSingleton<Talker>(talker);

  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );

  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  // Dio depends on secureStorage (via AuthInterceptor) — register after it.
  getIt.registerLazySingleton<ApiClient>(
  () => ApiClient(dio: getIt<Dio>()),
);
    getIt.registerLazySingleton<Dio>(() => DioClient.create());

  // ── Data sources ──────────────────────────────────────────────────────────
  // Registered as LazySingleton — one instance shared only via AuthRepository.
  // Not exposed as global getters; nothing outside the repo layer needs them.
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  // ── Repositories ──────────────────────────────────────────────────────────
  // Constructor injection — dependencies passed explicitly, not pulled from getIt.
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      
    ),
  );

  // ── BLoCs ─────────────────────────────────────────────────────────────────
  // registerFactory creates a new instance each time getIt<AuthBloc>() is called.
  // The BLoC receives its repository via constructor — no internal getIt calls.
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
    ),
  );
}