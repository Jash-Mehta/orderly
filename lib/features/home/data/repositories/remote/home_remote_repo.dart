
import 'package:orderly/features/home/data/model/dashboard_model.dart';

abstract interface class HomeRemoteRepo {
  Future<DashboardResponseModel> fetchHomeData();
 
}