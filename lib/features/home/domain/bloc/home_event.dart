part of 'home_bloc.dart';

sealed class HomeEvent{
  HomeEvent();
}

final class GetHomeData extends HomeEvent{
   GetHomeData();
}

final class AddToCart extends HomeEvent {
  final CreateOrderItem item;
  
  AddToCart({required this.item});
}

final class CreateOrder extends HomeEvent {
  CreateOrder();
}
