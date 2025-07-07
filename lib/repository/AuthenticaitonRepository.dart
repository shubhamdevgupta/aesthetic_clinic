import 'dart:convert';

import '../models/LoginResponse.dart';
import '../services/BaseApiService.dart';
import '../utils/GlobalExceptionHandler.dart';


class AuthenticaitonRepository {
  final BaseApiService _apiService = BaseApiService();

  Future<LoginResponse> loginUser(
      String phoneNumber, String password, String txtSalt, int appId) async {
    try {
      // Call the POST method from BaseApiService
      final response = await _apiService.post('APIMobile/Login',
        body: jsonEncode({
          'loginid': phoneNumber,
          'password': password,
          'txtSaltedHash': txtSalt,
           'App_id':appId
        }),
      );

      return LoginResponse.fromJson(response);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      rethrow;
    }
  }

}
