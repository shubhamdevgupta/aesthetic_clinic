import 'dart:convert';

import 'package:aesthetic_clinic/models/doctor/doctor_detail_response.dart';
import 'package:aesthetic_clinic/models/doctor/doctor_response.dart';

import '../models/banner_list.dart';
import '../models/doctor/get_review.dart';
import '../models/doctor/submit_doctor_review.dart';
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

  Future<ReviewResponse> submitReview(
      String rating,
      String review,
      String doctorId,
      ) async {
    try {
      final response = await _apiService.post(
        '/doctors/$doctorId/reviews',
        body: jsonEncode({'rating': rating, 'review': review}),
      withAuth: true);
      return ReviewResponse.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<DoctorReview> getReview(
      String doctorId) async {
    try {
      final response = await _apiService.get(
        '/doctors/$doctorId/reviews',
      withAuth: true);
      return DoctorReview.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }
}