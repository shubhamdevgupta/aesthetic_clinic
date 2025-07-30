
import 'package:aesthetic_clinic/models/all_services.dart';

import '../models/banner_list.dart';
import '../services/BaseApiService.dart';
import '../utils/GlobalExceptionHandler.dart';

class ServiceRepository{
  final BaseApiService _apiService = BaseApiService();


Future<ServiceResponse> getAllServices( ) async {
  try {
    // Call the POST method from BaseApiService
    final response = await _apiService.get('/services/list',withAuth: true);

    return ServiceResponse.fromJson(response);
  } catch (e) {
    GlobalExceptionHandler.handleException(e as Exception);
    rethrow;
  }
}
Future<AppConfigurationResponse> getBannerList( ) async {
  try {
    // Call the POST method from BaseApiService
    final response = await _apiService.get('/app-configs/list?page=1&limit=10&type=banner,offer&include=appConfigs,topServices',withAuth: true);

    return AppConfigurationResponse.fromJson(response);
  } catch (e) {
    GlobalExceptionHandler.handleException(e as Exception);
    rethrow;
  }
}

}