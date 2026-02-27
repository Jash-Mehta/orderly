import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:orderly/core/di/service_locator.dart';
import 'package:orderly/core/utils/methods/failure/app_failure.dart';
import 'package:orderly/core/api/api_result.dart';
import 'package:orderly/features/home/data/model/dashboard_model.dart';
import 'package:orderly/features/home/data/model/create_order_item.dart';
import 'package:orderly/features/home/data/model/create_order_payload.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  CreateOrderPayload? _cartPayload;
  String? _userId;

  HomeBloc() : super(const HomeInitialState()) {
    on<GetHomeData>(_onGetDashboardData);
    on<AddToCart>(_onAddToCart);
    on<CreateOrder>(_onCreateOrder);
  }

  // ── Dashboard ──────────────────────────────────────────────────────────────

  Future<void> _onGetDashboardData(
    GetHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoadingState());

    // Fetch userId and dashboard data concurrently
    final results = await Future.wait([
      authLocalDataSource.getUserId(),
      homeRepository.fetchHomeData(),
    ]);

      _userId = await authLocalDataSource.getUserId();
  talker.info('Fetched userId from storage: $_userId');
    final result = results[1] as Result<DashboardResponseModel>;

    switch (result) {
      case Success(:final value):
        emit(HomeLoadedState(
          homeresponse: value,
          cartPayload: _cartPayload,
          addCartClick: false,
        ));
      case Failure(:final failure):
        emit(HomeFailureState(failure: failure, addCartClick: false));
    }
  }

  // ── Add to Cart ────────────────────────────────────────────────────────────

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoadedState) return;

    final currentState = state as HomeLoadedState;
    final newItem = event.item;

    _cartPayload = _cartPayload == null
        ? CreateOrderPayload(
            userId: _userId ?? "",
            totalAmount: newItem.amount,
            status: 'PENDING',
            items: [newItem],
          )
        : _mergeItem(newItem);

    emit(currentState.copyWith(
      cartPayload: _cartPayload,
      addCartClick: true,
    ));
  }

  // ── Create Order ───────────────────────────────────────────────────────────

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<HomeState> emit,
  ) async {
    if (_cartPayload == null || state is! HomeLoadedState) return;

    final currentState = state as HomeLoadedState;

    emit(const HomeLoadingState());

    final result = await homeRepository.createOrder(_cartPayload!);

    switch (result) {
      case Success():
        _cartPayload = null;
        emit(currentState.copyWith(
          cartPayload: null,
          addCartClick: false,
        ));
      case Failure(:final failure):
        // Restore loaded state first, then emit failure
        emit(currentState.copyWith(
          cartPayload: _cartPayload,
          addCartClick: false,
        ));
        emit(HomeFailureState(failure: failure, addCartClick: false));
    }
  }

  // ── Private Helpers ────────────────────────────────────────────────────────

  CreateOrderPayload _mergeItem(CreateOrderItem newItem) {
    final items = List<CreateOrderItem>.from(_cartPayload!.items);
    final index = items.indexWhere((i) => i.productId == newItem.productId);

    if (index != -1) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + newItem.quantity,
        amount: items[index].amount + newItem.amount,
      );
    } else {
      items.add(newItem);
    }

    final total = items.fold(0.0, (sum, i) => sum + i.amount);

    return _cartPayload!.copyWith(items: items, totalAmount: total);
  }
}