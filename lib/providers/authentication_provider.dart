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

  OtpResponse? _otpResponse;
OtpResponse? get otpResponse => _otpResponse;

  AuthResponse? _authResponse;
  AuthResponse? get authResponse => _authResponse;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String errorMsg = '';

  final TextEditingController phoneController = TextEditingController();

  Future<void> checkLoginStatus() async {
    _isLoggedIn = _localStorage.getBool(AppConstants.prefIsLoggedIn) ?? false;
    notifyListeners();
  }

  Future<void> logoutUser() async {
    _isLoggedIn = false;
    await _localStorage.remove(AppConstants.prefIsLoggedIn);
    await _localStorage.clearAll();
    notifyListeners();
  }

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
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      _authResponse = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  String trim(String value) => value.trim();

  String sha512Base64(String input) {
    final List<int> bytes = utf8.encode(input);
    final Digest sha512Hash = sha512.convert(bytes);
    return base64Encode(sha512Hash.bytes);
  }

  String encryptPassword(String password, String salt) {
    String hash1 = sha512Base64(trim(password));
    String hash2 = sha512Base64(salt + hash1);
    return hash2;
  }

  /// Generates a random salt of the given length
  String generateSalt({int length = 16}) {
    final Random random = Random.secure();
    final List<int> saltBytes =
        List<int>.generate(length, (_) => random.nextInt(256));
    return base64Encode(saltBytes);
  }

}
