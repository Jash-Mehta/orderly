import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:orderly/core/di/service_locator.dart';
import 'package:orderly/core/utils/methods/failure/app_failure.dart';
import 'package:orderly/core/api/api_result.dart';

import 'package:orderly/features/home/data/model/dashboard_model.dart';



part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitialState()) {
    on<GetHomeData>(_onGetDashboardData);
   
  }

  Future<void> _onGetDashboardData(GetHomeData event, Emitter<HomeState> emit) async {
   emit(const HomeLoadingState());
   final result = await homeRepository.fetchHomeData();
   switch(result){
    case Success(:final value): emit(HomeLoadedState(homeresponse: value));
    case Failure(:final failure): emit(HomeFailureState(failure:failure )) ;
    
   }
   
  }

}