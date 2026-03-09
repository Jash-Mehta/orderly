import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/core/di/service_locator.dart';
import 'package:orderly/features/auth/domain/bloc/auth_bloc.dart';
import 'package:orderly/features/home/domain/bloc/home_bloc.dart';
import 'package:orderly/features/payments/domain/bloc/payment_bloc.dart';
import 'package:orderly/features/payments/data/repositories/payment_repository.dart';
import 'package:orderly/features/payments/data/repositories/payment_repository_impl.dart';
import 'package:orderly/features/shipments/data/repositories/shipment_repository.dart';
import 'package:orderly/features/shipments/data/repositories/shipment_repository_impl.dart';
import 'package:orderly/features/shipments/domain/bloc/shipment_bloc.dart';

class BlocProviderWrapper extends StatelessWidget {
  const BlocProviderWrapper({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthBloc>(),
        ),
         BlocProvider(
          create: (context) =>
              HomeBloc(),
        ),
        BlocProvider(
          create: (context) => PaymentBloc(
            paymentRepository: PaymentRepositoryImpl(),
          ),
        ),
          BlocProvider(
          create: (context) => ShipmentBloc(
            ShipmentRepositoryImpl(),
          ),
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
