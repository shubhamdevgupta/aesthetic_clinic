import 'package:aesthetic_clinic/models/service/all_services.dart';
import 'package:aesthetic_clinic/models/service/service_detail_response.dart';
import 'package:aesthetic_clinic/models/service/sub_service.dart';

import '../services/BaseApiService.dart';
import '../utils/GlobalExceptionHandler.dart';

class ServiceRepository {
  final BaseApiService _apiService = BaseApiService();

  Future<GetAllService> getMainServices() async {
    try {
      // Call the POST method from BaseApiService
      final response = await _apiService.get(
        '/services/main-services',
        withAuth: true,
      );

      return GetAllService.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<ServiceResponse> getSubService(String parentId) async {
    try {
      // Call the POST method from BaseApiService
      final response = await _apiService.get(
        '/services/main-services/$parentId',
        withAuth: true,
      );

      return ServiceResponse.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<ServiceDetailResponse> getServiceDetial(String serviceId) async {
    try {
      // Call the POST method from BaseApiService
      final response = await _apiService.get(
        '/services/$serviceId',
        withAuth: true,
      );

      return ServiceDetailResponse.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }
}
