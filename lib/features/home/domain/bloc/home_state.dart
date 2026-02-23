

part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitialState extends HomeState {
  const HomeInitialState();
}

final class HomeLoadingState extends HomeState {
  const HomeLoadingState();
}

final class HomeLoadedState extends HomeState {
  final DashboardResponseModel homeresponse;

  const HomeLoadedState({required this.homeresponse});

  @override
  List<Object?> get props => [homeresponse];
}


final class HomeFailureState extends HomeState {
  final AppFailure failure;

  const HomeFailureState({required this.failure});

  String get message => failure.message;

  @override
  List<Object?> get props => [failure];
}