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
import '../utils/CustomException.dart';
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
      // Don't handle AuthenticationException here - let GlobalExceptionHandler handle it
      if (e is! AuthenticationException) {
        GlobalExceptionHandler.handleException(e as Exception);
      }
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
        _localStorage.saveBool(AppConstants.prefIsLoggedIn, true);
        _isLoggedIn = true;
      }
    } catch (e) {
      // Don't handle AuthenticationException here - let GlobalExceptionHandler handle it
      if (e is! AuthenticationException) {
        GlobalExceptionHandler.handleException(e as Exception);
      }
      _verifyOtpResponse = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _localStorage.clearAll();
      _isLoggedIn = false;
      _sendotpResponse = null;
      _verifyOtpResponse = null;
      errorMsg = '';
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkAuthenticationState() async {
    final isLoggedIn = _localStorage.getBool(AppConstants.prefIsLoggedIn) ?? false;
    final accessToken = _localStorage.getString(AppConstants.prefAccessToken);
    
    if (isLoggedIn && accessToken != null && accessToken.isNotEmpty) {
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
      // Clear any invalid tokens
      await _localStorage.remove(AppConstants.prefAccessToken);
      await _localStorage.remove(AppConstants.prefRefreshToken);
      await _localStorage.remove(AppConstants.prefIsLoggedIn);
    }
    notifyListeners();
  }

  // Validation methods following MVVM structure
  String? validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      return 'Please enter a mobile number';
    }
    
    // Remove country code for validation
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'^\+\d+'), '');
    
    if (cleanPhone.isEmpty) {
      return 'Please enter a valid mobile number';
    }
    
    if (!RegExp(r'^\d+$').hasMatch(cleanPhone)) {
      return 'Mobile number can only contain digits';
    }
    
    // Additional validation for common phone number patterns
    if (cleanPhone.startsWith('0')) {
      return 'Please remove the leading zero from your mobile number';
    }
    
    // Check length after removing leading zero
    final finalPhone = cleanPhone.startsWith('0') ? cleanPhone.substring(1) : cleanPhone;
    
    if (finalPhone.length < 8) {
      return 'Mobile number must be at least 8 digits (excluding country code)';
    }
    
    if (finalPhone.length > 15) {
      return 'Mobile number cannot exceed 15 digits (excluding country code)';
    }
    
    // Country-specific validation
    final validationError = validatePhoneNumberForCountry(finalPhone, _selectedCountry);
    if (validationError != null) {
      return validationError;
    }
    
    return null; // No error
  }

  // Country-specific phone number validation
  String? validatePhoneNumberForCountry(String phoneNumber, Country country) {
    print("-------- $phoneNumber");
    switch (country.countryCode) {
      case 'AE': // UAE
        if (phoneNumber.length != 9) {
          return 'UAE mobile number must be 9 digits (excluding country code)';
        }
        if (!phoneNumber.startsWith('5')) {
          return 'UAE mobile number must start with 5';
        }
        break;
      case 'IN': // India
        if (!RegExp(r'^[6-9]').hasMatch(phoneNumber)) {
          return 'Indian mobile number must start with 6, 7, 8, or 9';
        }
        break;
      case 'US': // United States
        if (phoneNumber.length != 10) {
          return 'US mobile number must be 10 digits (excluding country code)';
        }
        break;
      case 'GB': // United Kingdom
        if (phoneNumber.length != 10) {
          return 'UK mobile number must be 10 digits (excluding country code)';
        }
        if (!phoneNumber.startsWith('7')) {
          return 'UK mobile number must start with 7';
        }
        break;
      default:
        // For other countries, just check basic length
        if (phoneNumber.length < 8 || phoneNumber.length > 15) {
          return 'Mobile number length is invalid for this country';
        }
    }
    
    return null; // No error
  }

  String? validateOtp(String otp) {
    if (otp.isEmpty) {
      return 'Please enter the OTP';
    }
    
    if (otp.length != 6) {
      return 'OTP must be exactly 6 digits';
    }
    
    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      return 'OTP can only contain digits (0-9)';
    }
    
    // Additional validation: Check if OTP contains only same digits (like 111111)
    if (RegExp(r'^(\d)\1{5}$').hasMatch(otp)) {
      return 'Please enter a valid OTP';
    }
    
    // Additional validation: Check if OTP is sequential (like 123456)
    if (otp == '123456') {
      return 'Please enter a valid OTP';
    }
    
    return null; // No error
  }

  // Method to send OTP with validation
  Future<bool> sendOtpWithValidation(String phoneNumber) async {
    // Step 1: Validate input first
    final validationError = validatePhoneNumber(phoneNumber);
    if (validationError != null) {
      errorMsg = validationError;
      notifyListeners();
      return false; // Stop here, don't call API
    }

    // Step 2: Clear previous error and call API only if validation passes
    errorMsg = '';
    notifyListeners();

    try {
      await sendOtp(phoneNumber);
      
      // Step 3: Handle API response
      if (_sendotpResponse?.statuscode == 200 && _sendotpResponse!.status) {
        return true;
      } else {
        // API returned error
        final apiMessage = _sendotpResponse?.message ?? 'Failed to send OTP. Please try again.';
        
        // Check if it's a server error
        if (_sendotpResponse?.statuscode == 500) {
          errorMsg = 'Server is temporarily unavailable. Please try again in a few moments.';
        } else {
          errorMsg = apiMessage;
        }
        
        notifyListeners();
        return false;
      }
    } catch (e) {
      // API call failed
      if (e.toString().contains('Server error') || e.toString().contains('temporarily unavailable')) {
        errorMsg = 'Server is temporarily unavailable. Please try again in a few moments.';
      } else {
        errorMsg = 'An error occurred. Please try again.';
      }
      notifyListeners();
      return false;
    }
  }

  // Method to verify OTP with validation
  Future<bool> verifyOtpWithValidation(String phoneNumber, String otp) async {
    // Step 1: Validate inputs first
    final phoneValidationError = validatePhoneNumber(phoneNumber);
    if (phoneValidationError != null) {
      errorMsg = phoneValidationError;
      notifyListeners();
      return false; // Stop here, don't call API
    }

    final otpValidationError = validateOtp(otp);
    if (otpValidationError != null) {
      errorMsg = otpValidationError;
      notifyListeners();
      return false; // Stop here, don't call API
    }

    // Step 2: Clear previous error and call API only if validation passes
    errorMsg = '';
    notifyListeners();

    try {
      await verifyOtp(phoneNumber, otp);
      
      // Step 3: Handle API response
      if (_verifyOtpResponse?.statuscode == 200 && _verifyOtpResponse!.status) {
        return true;
      } else {
        // API returned error
        final apiMessage = _verifyOtpResponse?.message ?? 'Invalid OTP. Please try again.';
        
        // Check if it's a server error
        if (_verifyOtpResponse?.statuscode == 500) {
          errorMsg = 'Server is temporarily unavailable. Please try again in a few moments.';
        } else {
          errorMsg = apiMessage;
        }
        
        notifyListeners();
        return false;
      }
    } catch (e) {
      // API call failed
      if (e.toString().contains('Server error') || e.toString().contains('temporarily unavailable')) {
        errorMsg = 'Server is temporarily unavailable. Please try again in a few moments.';
      } else {
        errorMsg = 'An error occurred. Please try again.';
      }
      notifyListeners();
      return false;
    }
  }

  // Method to clear error message
  void clearError() {
    errorMsg = '';
    notifyListeners();
  }

  // Method to format phone number for API
  String formatPhoneNumber(String countryCode, String phoneNumber) {
    // Remove any non-digit characters
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    // Remove leading zero if present
    final formattedPhone = cleanPhone.startsWith('0') ? cleanPhone.substring(1) : cleanPhone;
    
    // Return with country code
    return '$countryCode$formattedPhone';
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
