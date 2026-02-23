import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:talker_flutter/talker_flutter.dart';

class AppBlocObserver extends BlocObserver {
  AppBlocObserver(this.talker);

  final Talker talker;

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    talker.info('Bloc created: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    talker.debug('Event: ${bloc.runtimeType} - $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    talker.verbose('State changed: ${bloc.runtimeType}\n'
        'Current: ${change.currentState}\n'
        'Next: ${change.nextState}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    talker.info('Transition: ${bloc.runtimeType}\n'
        'Event: ${transition.event}\n'
        'Current: ${transition.currentState}\n'
        'Next: ${transition.nextState}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    talker.error('Bloc error: ${bloc.runtimeType}', error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    talker.info('Bloc closed: ${bloc.runtimeType}');
  }
}
