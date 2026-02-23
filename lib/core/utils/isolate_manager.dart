import 'dart:async';
import 'dart:isolate';
import 'package:talker_flutter/talker_flutter.dart';

class IsolateManager {
  static final Talker _talker = Talker();
  static final Map<String, SendPort> _isolates = {};
  static final Map<String, ReceivePort> _receivePorts = {};

  static Future<T> runInIsolate<T, P>({
    required String isolateName,
    required P params,
    required Future<T> Function(P params) computation,
  }) async {
    // 1. Creates a new isolate for heavy operations
    // 2. Passes parameters via SendPort/ReceivePort
    // 3. Runs computation in separate thread
    // 4. Returns result back to main thread
    try {
      if (_isolates.containsKey(isolateName)) {
        _talker.debug('Reusing existing isolate: $isolateName');
      }

      final receivePort = ReceivePort();
      final completer = Completer<T>();

      _receivePorts[isolateName] = receivePort;

      receivePort.listen((message) {
        if (message is T) {
          completer.complete(message);
        } else if (message is Exception) {
          completer.completeError(message);
        }
      });

      await Isolate.spawn(
        _isolateEntryPoint<T, P>,
        _IsolateParams<P>(
          params: params,
          sendPort: receivePort.sendPort,
          computation: computation,
        ),
        debugName: isolateName,
      );

      _talker.info('Isolate $isolateName started successfully');
      return await completer.future;
    } catch (e, stackTrace) {
      _talker.error('Error in isolate $isolateName', e, stackTrace);
      rethrow;
    } finally {
      _cleanupIsolate(isolateName);
    }
  }

  static void _isolateEntryPoint<T, P>(_IsolateParams<P> params) async {
    try {
      final result = await params.computation(params.params);
      params.sendPort.send(result);
    } catch (e) {
      params.sendPort.send(e as Exception);
    }
  }

  static void _cleanupIsolate(String isolateName) {
    _receivePorts[isolateName]?.close();
    _receivePorts.remove(isolateName);
    _isolates.remove(isolateName);
    _talker.debug('Isolate $isolateName cleaned up');
  }

  static Future<void> disposeAll() async {
    for (final receivePort in _receivePorts.values) {
      receivePort.close();
    }
    _receivePorts.clear();
    _isolates.clear();
    _talker.info('All isolates disposed');
  }
}

class _IsolateParams<P> {
  final P params;
  final SendPort sendPort;
  final Future Function(P params) computation;

  _IsolateParams({
    required this.params,
    required this.sendPort,
    required this.computation,
  });
}
