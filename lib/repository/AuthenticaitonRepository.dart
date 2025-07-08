import 'dart:convert';

import 'package:aesthetic_clinic/models/auth_response.dart';

import '../models/otp_response.dart';
import '../services/BaseApiService.dart';
import '../utils/GlobalExceptionHandler.dart';


class AuthenticaitonRepository {
  final BaseApiService _apiService = BaseApiService();

  Future<OtpResponse> sendOtp(
      String phoneNumber ) async {
    try {
      // Call the POST method from BaseApiService
      final response = await _apiService.post('/auth/mobile-login',
        body: jsonEncode({
          'phone': phoneNumber
        }),
      );

      return OtpResponse.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<AuthResponse> verifyOtp(
      String phoneNumber, String otp) async {
    try {
      // Call the POST method from BaseApiService
      final response = await _apiService.post('/auth/mobile-login',
        body: jsonEncode({
          'phone': phoneNumber,
          'otp': otp,
          'deviceInfo': "Mobile App",
        }),
      );

      return AuthResponse.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

}
