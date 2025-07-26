import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aesthetic_clinic/repository/AuthenticaitonRepository.dart';
import 'package:aesthetic_clinic/utils/AppConstants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import '../utils/CustomException.dart';
import 'LocalStorageService.dart';

class BaseApiService {
  final String _baseUrl = 'https://api.amaraclinics.ae/api';
  LocalStorageService storageService = LocalStorageService();

  Future<dynamic> post(
      String endpoint, {
        Map<String, String>? headers,
        dynamic body,
        bool withAuth = false,
      }) async {
    final Uri url = Uri.parse('$_baseUrl$endpoint');

    headers ??= {};
    headers.putIfAbsent('Content-Type', () => 'application/json');

    if (withAuth) {
      final accessToken =
      await storageService.getString(AppConstants.prefAccessToken);
      headers['Authorization'] = 'Bearer $accessToken';
    }

    log('POST Request: $url');
    log('POST Body: $body');
    log('POST Headers: $headers');

    try {
      await _checkConnectivity();
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 401 && withAuth) {
        bool refreshed = await _refreshAccessToken();
        if (refreshed) {
          final newAccessToken =
          await storageService.getString(AppConstants.prefAccessToken);
          headers['Authorization'] = 'Bearer $newAccessToken';
          response = await http.post(url, headers: headers, body: body);
        }
      }

      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      log('POST Exception: $e');
      throw ApiException('Unexpected error during POST');
    }
  }

  Future<dynamic> get(
      String endpoint, {
        Map<String, String>? headers,
        bool withAuth = false,
      }) async {
    final Uri url = Uri.parse('$_baseUrl$endpoint');

    headers ??= {};
    headers.putIfAbsent('Content-Type', () => 'application/json');

    if (withAuth) {
      final accessToken =
      await storageService.getString(AppConstants.prefAccessToken);
      headers['Authorization'] = 'Bearer $accessToken';
    }

    log('GET Request: $url\nHeaders: $headers');

    try {
      await _checkConnectivity();
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 401 && withAuth) {
        bool refreshed = await _refreshAccessToken();
        if (refreshed) {
          final newAccessToken =
          await storageService.getString(AppConstants.prefAccessToken);
          headers['Authorization'] = 'Bearer $newAccessToken';
          response = await http.get(url, headers: headers);
        }
      }

      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      log('GET Exception: $e');
      throw ApiException('Unexpected error during GET');
    }
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkException(
          'No internet connection. Please check your connection and try again.');
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw ApiException(
            'Bad Request ${handleErrorResp(response.body, '')}');
      case 404:
        throw ApiException('Page not found (404). Please contact admin');
      case 401:
        throw ApiException(
            'Unauthorized ${handleErrorResp(response.body, '')}');
      case 500:
        throw ApiException(
            handleErrorResp(response.body, 'Internal Server Error'));
      case 502:
        throw ApiException(
            'Bad Gateway ${handleErrorResp(response.body, '')}');
      case 408:
        throw ApiException('Request Timeout: Please try again later');
      default:
        throw ApiException(
            'Unexpected error ${response.statusCode} \n ${handleErrorResp(response.body, '')}');
    }
  }

  String handleErrorResp(String responseBody, String defMessage) {
    try {
      final Map<String, dynamic> jsonData = jsonDecode(responseBody);
      final String message = jsonData['ExceptionMessage'] ??
          jsonData['message'] ??
          defMessage;
      return " $message";
    } catch (_) {
      return defMessage;
    }
  }

  Future<bool> _refreshAccessToken() async {
    final refreshToken =
    await storageService.getString(AppConstants.prefRefresToken);
    final expiredAccessToken =
    await storageService.getString(AppConstants.prefAccessToken);

    if (refreshToken == null || expiredAccessToken == null) return false;

    final Uri url = Uri.parse('$_baseUrl/auth/refresh');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'text/plain',
        },
        body: expiredAccessToken, // raw body
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final newAccessToken = json['data']['accessToken'];
        final newRefreshToken = json['data']['refreshToken'];

        await storageService.saveString(
            AppConstants.prefRefresToken, newRefreshToken);
        await storageService.saveString(
            AppConstants.prefAccessToken, newAccessToken);
        return true;
      } else {
        log('Refresh token failed: ${response.body}');
        return false;
      }
    } catch (e) {
      log('Refresh token exception: $e');
      return false;
    }
  }
}
