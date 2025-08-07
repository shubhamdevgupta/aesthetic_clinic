import 'dart:convert';
import 'dart:math';

import 'package:aesthetic_clinic/models/verify_otp_response.dart';
import 'package:country_picker/country_picker.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';

import '../models/send_otp_response.dart';
import '../repository/AuthenticaitonRepository.dart';
import '../services/LocalStorageService.dart';
import '../utils/AppConstants.dart';
import '../utils/GlobalExceptionHandler.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthenticaitonRepository _authRepository = AuthenticaitonRepository();
  final LocalStorageService _localStorage = LocalStorageService();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  SendOtpResponseModel? _sendotpResponse;
  SendOtpResponseModel? get sendOtpResponse => _sendotpResponse;

  VerifyOtpResponseModel? _verifyOtpResponse;
  VerifyOtpResponseModel? get verifyOtpResponse => _verifyOtpResponse;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String errorMsg = '';
  String countryCode='';
  final TextEditingController phoneController = TextEditingController();


  // Method to login user
  Future<void> sendOtp(String phoneNumber) async {
    _isLoading = true;
    notifyListeners();
    try {
      _sendotpResponse = await _authRepository.sendOtp(phoneNumber);
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      _sendotpResponse = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    _isLoading = true;
    notifyListeners();
    try {
      _verifyOtpResponse = await _authRepository.verifyOtp(phoneNumber,otp);
      if(_verifyOtpResponse!.status&& _verifyOtpResponse!.statuscode==200){
        _localStorage.saveString(AppConstants.prefAccessToken, _verifyOtpResponse!.data.accessToken);
        _localStorage.saveString(AppConstants.prefRefreshToken, _verifyOtpResponse!.data.refreshToken);
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      _verifyOtpResponse = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Country _selectedCountry = Country(
    phoneCode: '971',
    countryCode: 'AED',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'United Arab Emirates',
    example: '2015550123',
    displayName: 'United Arab Emirates',
    displayNameNoCountryCode: 'United Arab Emirates',
    e164Key: '',
  );

  Country get selectedCountry => _selectedCountry;

  void setSelectedCountry(Country country) {
    _selectedCountry = country;
    notifyListeners();
  }

}
