import 'dart:async';

import 'package:aesthetic_clinic/models/verify_otp_response.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';

import '../models/send_otp_response.dart';
import '../repository/AuthenticaitonRepository.dart';
import '../services/LocalStorageService.dart';
import '../services/ui_state.dart';
import '../utils/AppConstants.dart';
import '../utils/CustomException.dart';
import '../utils/GlobalExceptionHandler.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthenticaitonRepository _authRepository = AuthenticaitonRepository();
  final LocalStorageService _localStorage = LocalStorageService();

  String errorMsg = '';
  final TextEditingController phoneController = TextEditingController();

  UiState<SendOtpResponseModel> sendOtpState = Idle();
  UiState<VerifyOtpResponseModel> verifyOtpState = Idle();

  bool isLoggedIn = false;
  VerifyOtpResponseModel? _verifyOtpResponse;

   late Timer timer ;
  int start = 30; // countdown duration
  bool canResend = false;

  void startTimer() {
    start = 30;
    canResend = false;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start == 0) {
          canResend = true;
        timer.cancel();
      } else {
          start--;
      }
    });
  }
  Country _selectedCountry = Country(
    phoneCode: '971',
    countryCode: 'AE',
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

  // ======================
  // SIMPLE VALIDATIONS
  // ======================
  String? validatePhoneNumber(String phoneNumber) {
    final clean = phoneNumber.replaceAll(RegExp(r'\s+|-'), '');
    if (clean.isEmpty) return 'Please enter a phone number';
    if (!RegExp(r'^\d+$').hasMatch(clean)) return 'Phone must contain only digits';
    if (clean.length < 7 || clean.length > 15) return 'Please enter a valid phone number';
    return null;
  }

  String? validateOtp(String otp) {
    if (otp.isEmpty) return 'Please enter the OTP';
    if (otp.length != 6) return 'OTP must be exactly 6 digits';
    if (!RegExp(r'^\d{6}$').hasMatch(otp)) return 'OTP must contain only digits';
    if (RegExp(r'^(\d)\1{5}$').hasMatch(otp)) return 'Invalid OTP';
    if (otp == '123456') return 'Invalid OTP';
    return null;
  }

  // ======================
  // AUTH FLOW WITH STATE
  // ======================

  Future<void> sendOtp(String phoneNumber) async {
    final error = validatePhoneNumber(phoneNumber);
    if (error != null) {
      errorMsg = error;
      sendOtpState = Error(error);
      notifyListeners();
      return;
    }

    sendOtpState = Loading();
    notifyListeners();

    try {
      final response = await _authRepository.sendOtp(phoneNumber);
      if (response.status && response.statuscode == 200) {
        sendOtpState = Success(response);
      } else {
        sendOtpState = Error("Unexpected response");
      }
    } on NetworkException {
      sendOtpState = NoInternet();
    } on AuthenticationException {
      sendOtpState = Error("Authentication failed");
    } catch (e) {
      sendOtpState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    final phoneError = validatePhoneNumber(phoneNumber);
    final otpError = validateOtp(otp);

    if (phoneError != null || otpError != null) {
      errorMsg = phoneError ?? otpError!;
      verifyOtpState = Error(errorMsg);
      notifyListeners();
      return;
    }

    verifyOtpState = Loading();
    notifyListeners();

    try {
      final response = await _authRepository.verifyOtp(phoneNumber, otp);
      if (response.status && response.statuscode == 200) {
        await _saveUserSession(response);
        isLoggedIn = true;
        _verifyOtpResponse = response;
        verifyOtpState = Success(response);
      } else {
        verifyOtpState = Error("Invalid OTP or server error");
      }
    } on AuthenticationException {
      verifyOtpState = Error("Authentication failed");
    } catch (e) {
      verifyOtpState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    verifyOtpState = Loading();
    notifyListeners();

    try {
      await _localStorage.clearAll();
      isLoggedIn = false;
      _verifyOtpResponse = null;
      phoneController.text = '';
      errorMsg = '';
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      verifyOtpState = Error("Failed to logout: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> checkAuthenticationState() async {
    final storedLoggedIn = _localStorage.getBool(AppConstants.prefIsLoggedIn) ?? false;
    final token = _localStorage.getString(AppConstants.prefAccessToken);

    isLoggedIn = storedLoggedIn && token != null && token.isNotEmpty;
    notifyListeners();
  }

  // ======================
  // HELPERS
  // ======================
  Future<void> _saveUserSession(VerifyOtpResponseModel response) async {
    await _localStorage.saveString(
      AppConstants.prefAccessToken,
      response.data.accessToken,
    );
    await _localStorage.saveString(
      AppConstants.prefRefreshToken,
      response.data.refreshToken,
    );
    await _localStorage.saveString(
      AppConstants.prefUserId,
      response.data.user.id,
    );
    await _localStorage.saveString(
      AppConstants.prefFirstName,
      response.data.user.firstName,
    );
    await _localStorage.saveString(
      AppConstants.prefLastName,
      response.data.user.lastName,
    );
    await _localStorage.saveString(
      AppConstants.prefMobile,
      response.data.user.phone,
    );
    await _localStorage.saveString(
      AppConstants.prefEmail,
      response.data.user.email ?? '',
    );
    await _localStorage.saveBool(AppConstants.prefIsLoggedIn, true);
  }

  void clearError() {
    errorMsg = '';
    notifyListeners();
  }

  String formatPhoneNumber(String countryCode, String phoneNumber) {
    final clean = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    final formatted = clean.startsWith('0') ? clean.substring(1) : clean;
    return '$countryCode$formatted';
  }
}
