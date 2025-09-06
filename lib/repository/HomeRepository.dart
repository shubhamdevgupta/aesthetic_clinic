import 'package:aesthetic_clinic/models/doctor/doctor_detail_response.dart';
import 'package:aesthetic_clinic/models/doctor/doctor_response.dart';

import '../models/banner_list.dart';
import '../services/BaseApiService.dart';
import '../utils/GlobalExceptionHandler.dart';

class HomeRepository{
  final BaseApiService _apiService = BaseApiService();


  Future<AppConfigurationResponse> getDashboardData( ) async {
      final response = await _apiService.get(
          '/app-configs/list',withAuth: true);
      return AppConfigurationResponse.fromJson(response);
  }
  Future<DoctorResponse> getDoctorData() async {
      final response = await _apiService.get(
          '/doctors',withAuth: true);

      return DoctorResponse.fromJson(response);
  }
  Future<DoctorDetailModel> getDoctorbyId(String doctorId) async {
      final response = await _apiService.get(
          '/doctors/$doctorId',withAuth: true);

      return DoctorDetailModel.fromJson(response);
  }
}