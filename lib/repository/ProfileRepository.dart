import 'dart:convert';

import 'package:aesthetic_clinic/models/profile/update_profile.dart';

import '../models/profile/profile_data.dart';
import '../services/BaseApiService.dart';
import '../utils/GlobalExceptionHandler.dart';

class Profilerepository {
  final BaseApiService _apiService = BaseApiService();

  Future<ProfileResponse> getUserProfile() async {
    try {
      // Call the POST method from BaseApiService
      final response = await _apiService.get('/profile', withAuth: true);

      return ProfileResponse.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

  Future<UpdateProfileResponse> updateUserProfile(
    String firstName,
    String lastName,
    String emailId,
  ) async {
    try {
      final response = await _apiService.put(
        '/profile/update',
        withAuth: true,
        body: jsonEncode({
          "firstName": firstName,
          "lastName": lastName,
          "email": emailId,
        }),
      );

      return UpdateProfileResponse.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }
}
