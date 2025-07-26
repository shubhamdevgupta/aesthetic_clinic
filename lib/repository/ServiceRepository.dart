
import 'package:aesthetic_clinic/models/all_services.dart';

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

}