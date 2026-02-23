import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:orderly/core/bloc_observer/app_bloc_observer.dart';
import 'package:orderly/core/di/service_locator.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/core/ui/widgets/app_loader_animated.dart';
import 'package:orderly/core/ui/widgets/error_widget.dart';
import 'package:orderly/core/utils/assets/assets.dart';
import 'package:orderly/main.dart';
import 'package:talker_flutter/talker_flutter.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create talker first — everything else may need to log during init.
  final talker = TalkerFlutter.init();

  // Await services so the app never starts with unregistered dependencies.
  await initServices(talker);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  _configureEasyLoading();

  // Use the same talker instance registered in the service locator.
  FlutterError.onError = (FlutterErrorDetails details) {
    talker.handle(details.exception, details.stack);
  };

  // Catches async errors not caught by FlutterError (e.g. in isolates).
  PlatformDispatcher.instance.onError = (error, stack) {
    talker.handle(error, stack);
    return true;
  };

  Bloc.observer = AppBlocObserver(talker);

  ErrorWidget.builder = (errorDetails) => AppErrorWidget(
        topSpacing: 100,
        errorTitle: 'Oops! Something went wrong',
        errorMessage: 'An unexpected error occurred. Please try again later.',
        stack: errorDetails.stack.toString(),
        assetsImage: Assets.somethingWentWrong,
        buttonText: 'Reload App',
        onTap: () {},
      );

  runApp(const MyApp());
}

void _configureEasyLoading() {
  EasyLoading.instance
    ..indicatorWidget = appLoaderAnimated()
    ..indicatorSize = 80.0
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.transparent
    ..textColor = AppColors.white
    ..loadingStyle = EasyLoadingStyle.custom
    ..boxShadow = []
    ..radius = 8.0;
}