import 'package:aesthetic_clinic/models/doctor/doctor_detail_response.dart';
import 'package:aesthetic_clinic/models/doctor/doctor_response.dart';

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
  Future<DoctorResponse> getDoctorData() async {
    try {
      final response = await _apiService.get(
          '/doctors',withAuth: true);

      return DoctorResponse.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }
  Future<DoctorDetailModel> getDoctorbyId(String doctorId) async {
    try {
      final response = await _apiService.get(
          '/doctors/$doctorId',withAuth: true);

      return DoctorDetailModel.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }
}