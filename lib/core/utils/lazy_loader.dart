import 'dart:async';
import 'package:talker_flutter/talker_flutter.dart';

class LazyLoader {
  static final Talker _talker = Talker();
  static final Map<String, Future<dynamic>> _loadingCache = {};
  static final Map<String, dynamic> _loadedCache = {};

  static Future<T> load<T>({
    required String key,
    required Future<T> Function() loader,
    Duration? timeout = const Duration(seconds: 30),
    bool cache = true,
  }) async {
    if (!cache) {
      return await _executeLoader(key, loader, timeout);
    }

    if (_loadedCache.containsKey(key)) {
      _talker.debug('Returning cached value for key: $key');
      return _loadedCache[key] as T;
    }

    if (_loadingCache.containsKey(key)) {
      _talker.debug('Waiting for existing load for key: $key');
      return await _loadingCache[key] as T;
    }

    _talker.info('Starting lazy load for key: $key');
    final future = _executeLoader(key, loader, timeout);
    _loadingCache[key] = future;

    try {
      final result = await future;
      _loadedCache[key] = result;
      _loadingCache.remove(key);
      _talker.info('Successfully loaded and cached key: $key');
      return result;
    } catch (e, stackTrace) {
      _loadingCache.remove(key);
      _talker.error('Failed to load key: $key', e, stackTrace);
      rethrow;
    }
  }

  static Future<T> _executeLoader<T>(
    String key,
    Future<T> Function() loader,
    Duration? timeout,
  ) async {
    try {
      if (timeout != null) {
        return await loader().timeout(timeout);
      } else {
        return await loader();
      }
    } catch (e) {
      _talker.error('Loader execution failed for key: $key', e);
      rethrow;
    }
  }

  static T? getCached<T>(String key) {
    if (_loadedCache.containsKey(key)) {
      return _loadedCache[key] as T;
    }
    return null;
  }

  static bool isLoaded(String key) {
    return _loadedCache.containsKey(key);
  }

  static bool isLoading(String key) {
    return _loadingCache.containsKey(key);
  }

  static void clearCache([String? key]) {
    if (key != null) {
      _loadedCache.remove(key);
      _loadingCache.remove(key);
      _talker.debug('Cleared cache for key: $key');
    } else {
      _loadedCache.clear();
      _loadingCache.clear();
      _talker.info('Cleared all cache');
    }
  }

  static void preload<T>({
    required String key,
    required Future<T> Function() loader,
    Duration? timeout,
  }) {
    if (!isLoaded(key) && !isLoading(key)) {
      _talker.info('Preloading key: $key');
      unawaited(load(key: key, loader: loader, timeout: timeout));
    }
  }
}

extension UnawaitedExtension on Future<void> {
  static void unawaited(Future<void> future) {
    // Intentionally not awaiting the future
  }
}
