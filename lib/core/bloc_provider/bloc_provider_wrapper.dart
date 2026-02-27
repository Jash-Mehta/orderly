import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/core/di/service_locator.dart';
import 'package:orderly/features/auth/domain/bloc/auth_bloc.dart';
import 'package:orderly/features/home/domain/bloc/home_bloc.dart';

class BlocProviderWrapper extends StatelessWidget {
  const BlocProviderWrapper({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthCheckRequested()),
        ),
         BlocProvider(
          create: (context) =>
              HomeBloc(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return child;
        },
      ),
    );
  }
}
