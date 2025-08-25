import '../models/banner_list.dart';
import '../services/BaseApiService.dart';
import '../utils/GlobalExceptionHandler.dart';

class HomeRepository{
  final BaseApiService _apiService = BaseApiService();


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