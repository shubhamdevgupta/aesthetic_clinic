import 'dart:convert';
import 'dart:math';

import 'package:aesthetic_clinic/models/auth_response.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';

import '../models/otp_response.dart';
import '../repository/AuthenticaitonRepository.dart';
import '../services/LocalStorageService.dart';
import '../utils/AppConstants.dart';
import '../utils/GlobalExceptionHandler.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthenticaitonRepository _authRepository = AuthenticaitonRepository();
  final LocalStorageService _localStorage = LocalStorageService();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  OtpResponseModel? _otpResponse;
OtpResponseModel? get otpResponse => _otpResponse;

  LoginResponseModel? _authResponse;
  LoginResponseModel? get authResponse => _authResponse;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String errorMsg = '';

  final TextEditingController phoneController = TextEditingController();


  // Method to login user
  Future<void> sendOtp(String phoneNumber) async {
    _isLoading = true;
    notifyListeners();
    try {
      _otpResponse = await _authRepository.sendOtp(phoneNumber);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      _otpResponse = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    _isLoading = true;
    notifyListeners();
    try {
      _authResponse = await _authRepository.verifyOtp(phoneNumber,otp);
      if(_authResponse!.status&& _authResponse!.statuscode==200){
        _localStorage.saveString(AppConstants.prefAccessToken, _authResponse!.data.accessToken);
        _localStorage.saveString(AppConstants.prefRefresToken, _authResponse!.data.refreshToken);
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      _authResponse = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


}
