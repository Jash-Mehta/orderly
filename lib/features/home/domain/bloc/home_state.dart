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
  final CreateOrderPayload? cartPayload;
  final bool addCartClick;

  const HomeLoadedState({
    required this.homeresponse,
    this.cartPayload,
    this.addCartClick = false,
  });

  HomeLoadedState copyWith({
    DashboardResponseModel? homeresponse,
    CreateOrderPayload? cartPayload,
    bool? addCartClick,
  }) {
    return HomeLoadedState(
      homeresponse: homeresponse ?? this.homeresponse,
      cartPayload: cartPayload ?? this.cartPayload,
      addCartClick: addCartClick ?? this.addCartClick,
    );
  }

  @override
  List<Object?> get props => [homeresponse, cartPayload, addCartClick];
}

final class HomeFailureState extends HomeState {
  final AppFailure failure;
  final bool addCartClick;

  const HomeFailureState({required this.failure, this.addCartClick = false});

  String get message => failure.message;

  @override
  List<Object?> get props => [failure, addCartClick]; // was also missing addCartClick
}