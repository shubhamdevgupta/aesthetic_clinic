
import 'package:aesthetic_clinic/models/all_services.dart';
import 'package:aesthetic_clinic/models/service_detail_response.dart';
import 'package:flutter/foundation.dart';

import '../models/banner_list.dart';
import '../services/BaseApiService.dart';
import '../utils/GlobalExceptionHandler.dart';

class ServiceRepository{
  final BaseApiService _apiService = BaseApiService();


Future<GetAllService> getAllServices( ) async {
  try {
    // Call the POST method from BaseApiService
    final response = await _apiService.get('/services/list',withAuth: true);

    return GetAllService.fromJson(response);
  } catch (e) {
    GlobalExceptionHandler.handleException(e as Exception);
    rethrow;
  }
}

Future<ServiceDetailResponse> getServicebyID(String serviceId) async {
  try {
    // Call the POST method from BaseApiService
    final response = await _apiService.get('/services/$serviceId',withAuth: true);

    return ServiceDetailResponse.fromJson(response);
  } catch (e) {
    GlobalExceptionHandler.handleException(e as Exception);
    rethrow;
  }
}

Future<AppConfigurationResponse> getDashboardData( ) async {
  try {
    final response = await _apiService.get(
        '/app-configs/list',withAuth: true);

    return AppConfigurationResponse.fromJson(response);
  } catch (e) {
    GlobalExceptionHandler.handleException(e as Exception);
    rethrow;
  }
}

}