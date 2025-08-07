import 'dart:convert';

import 'package:aesthetic_clinic/models/verify_otp_response.dart';

import '../models/send_otp_response.dart';
import '../services/BaseApiService.dart';
import '../utils/GlobalExceptionHandler.dart';


class AuthenticaitonRepository {
  final BaseApiService _apiService = BaseApiService();

  Future<SendOtpResponseModel> sendOtp(
      String phoneNumber ) async {
    try {
      // Call the POST method from BaseApiService
      final response = await _apiService.post('/auth/mobile-login',
        body: jsonEncode({
          'phone': phoneNumber
        }),
      );

      return SendOtpResponseModel.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<VerifyOtpResponseModel> verifyOtp(
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

      return VerifyOtpResponseModel.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future <SendOtpResponseModel> refreshToken(String authToken)async{
    try {
      // Call the POST method from BaseApiService
      final response = await _apiService.post('/auth/refresh',
        body: authToken
      );

      return SendOtpResponseModel.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }


}
