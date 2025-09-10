import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aesthetic_clinic/utils/AppConstants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../utils/CustomException.dart';
import 'LocalStorageService.dart';

class BaseApiService {
  final String _baseUrl = 'https://api.amaraclinics.ae/api';
  final LocalStorageService storageService = LocalStorageService();

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

    log('🔹 POST Request to: $url');
    log('🔸 Headers: ${jsonEncode(headers)}');
    log('🔸 Body: $body');

    int retryCount = 0;
    const maxRetries = 2;

    while (retryCount <= maxRetries) {
      try {
        await _checkConnectivity();

        var response = await http.post(url, headers: headers, body: body);

        log('📩 Response Status: ${response.statusCode}');
        log('📩 Response Body: ${response.body}');

        if (response.statusCode == 401 && withAuth) {
          log('🔄 Access token expired. Trying to refresh...');
          bool refreshed = await _refreshAccessToken();

          if (refreshed) {
            final newAccessToken =
            await storageService.getString(AppConstants.prefAccessToken);
            if (newAccessToken != null && newAccessToken.isNotEmpty) {
              headers['Authorization'] = 'Bearer $newAccessToken';

              log('🔁 Retrying POST with refreshed token...');
              response = await http.post(url, headers: headers, body: body);

              log('📩 Retried Response Status: ${response.statusCode}');
              log('📩 Retried Response Body: ${response.body}');
            } else {
              log('❌ Failed to get new access token after refresh');
              await logout();
              throw AuthenticationException('Authentication failed. Please login again.');
            }
          } else {
            log('❌ Token refresh failed. User needs to login again.');
            await logout();
            throw AuthenticationException('Session expired. Please login again.');
          }
        }

        // Check if it's a server error that we should retry
        if ((response.statusCode >= 500 && response.statusCode < 600) && retryCount < maxRetries) {
          log('⚠️ Server error (${response.statusCode}), retrying in 1 second... (Attempt ${retryCount + 1}/${maxRetries + 1})');
          await Future.delayed(const Duration(seconds: 1));
          retryCount++;
          continue;
        }

        return _processResponse(response);
      } on SocketException {
        throw NetworkException('No internet connection');
      } catch (e) {
        if (e is AuthenticationException) {
          log('❌ POST Auth Exception: $e');
          throw e;
        }
        if (e is ApiException) {
          // If it's already an ApiException, check if it's a server error we should retry
          if (e.toString().contains('Server error') && retryCount < maxRetries) {
            log('⚠️ Server error exception, retrying in 1 second... (Attempt ${retryCount + 1}/${maxRetries + 1})');
            await Future.delayed(const Duration(seconds: 1));
            retryCount++;
            continue;
          }
          throw e; // Re-throw ApiException as is
        }
        
        log('❌ POST Exception: $e');
        throw ApiException('Unexpected error during POST');
      }
    }
    
    // This should never be reached, but just in case
    throw ApiException('Failed after all retry attempts');
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

    log('🔹 GET Request to: $url');
    log('🔸 Headers: ${jsonEncode(headers)}');

    int retryCount = 0;
    const maxRetries = 2;

    while (retryCount <= maxRetries) {
      try {
        await _checkConnectivity();

        var response = await http.get(url, headers: headers);

        log('📩 Response Status: ${response.statusCode}');
        log('📩 Response Body: ${response.body}');

        if (response.statusCode == 401 && withAuth) {
          log('🔄 Access token expired. Trying to refresh...');
          bool refreshed = await _refreshAccessToken();

          if (refreshed) {
            final newAccessToken =
            await storageService.getString(AppConstants.prefAccessToken);
            if (newAccessToken != null && newAccessToken.isNotEmpty) {
              headers['Authorization'] = 'Bearer $newAccessToken';

              log('🔁 Retrying GET with refreshed token...');
              response = await http.get(url, headers: headers);

              log('📩 Retried Response Status: ${response.statusCode}');
              log('📩 Retried Response Body: ${response.body}');
            } else {
              log('❌ Failed to get new access token after refresh');
              throw AuthenticationException('Authentication failed. Please login again.');
            }
          } else {
            log('❌ Token refresh failed. User needs to login again.');
            await logout();
            throw AuthenticationException('Session expired. Please login again.');
          }
        }

        // Check if it's a server error that we should retry
        if ((response.statusCode >= 500 && response.statusCode < 600) && retryCount < maxRetries) {
          log('⚠️ Server error (${response.statusCode}), retrying in 1 second... (Attempt ${retryCount + 1}/${maxRetries + 1})');
          await Future.delayed(const Duration(seconds: 1));
          retryCount++;
          continue;
        }

        return _processResponse(response);
      } on SocketException {
        throw NetworkException('No internet connection');
      } catch (e) {
        if (e is AuthenticationException) {
          log('❌ GET Auth Exception: $e');
          throw e;
        }
        if (e is ApiException) {
          // If it's already an ApiException, check if it's a server error we should retry
          if (e.toString().contains('Server error') && retryCount < maxRetries) {
            log('⚠️ Server error exception, retrying in 1 second... (Attempt ${retryCount + 1}/${maxRetries + 1})');
            await Future.delayed(const Duration(seconds: 1));
            retryCount++;
            continue;
          }
          throw e; // Re-throw ApiException as is
        }
        
        log('❌ GET Exception: $e');
        throw ApiException('Unexpected error during GET');
      }
    }
    
    // This should never be reached, but just in case
    throw ApiException('Failed after all retry attempts');
  }

  Future<dynamic> put(
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

    log('🔹 PUT Request to: $url');
    log('🔸 Headers: ${jsonEncode(headers)}');
    log('🔸 Body: $body');

    int retryCount = 0;
    const maxRetries = 2;

    while (retryCount <= maxRetries) {
      try {
        await _checkConnectivity();

        var response = await http.put(url, headers: headers, body: body);

        log('📩 Response Status: ${response.statusCode}');
        log('📩 Response Body: ${response.body}');

        if (response.statusCode == 401 && withAuth) {
          log('🔄 Access token expired. Trying to refresh...');
          bool refreshed = await _refreshAccessToken();

          if (refreshed) {
            final newAccessToken =
            await storageService.getString(AppConstants.prefAccessToken);
            if (newAccessToken != null && newAccessToken.isNotEmpty) {
              headers['Authorization'] = 'Bearer $newAccessToken';

              log('🔁 Retrying PUT with refreshed token...');
              response = await http.put(url, headers: headers, body: body);

              log('📩 Retried Response Status: ${response.statusCode}');
              log('📩 Retried Response Body: ${response.body}');
            } else {
              log('❌ Failed to get new access token after refresh');
              await logout();
              throw AuthenticationException(
                  'Authentication failed. Please login again.');
            }
          } else {
            log('❌ Token refresh failed. User needs to login again.');
            await logout();
            throw AuthenticationException('Session expired. Please login again.');
          }
        }

        // Retry on server error
        if ((response.statusCode >= 500 && response.statusCode < 600) &&
            retryCount < maxRetries) {
          log('⚠️ Server error (${response.statusCode}), retrying in 1 second... (Attempt ${retryCount + 1}/${maxRetries + 1})');
          await Future.delayed(const Duration(seconds: 1));
          retryCount++;
          continue;
        }

        return _processResponse(response);
      } on SocketException {
        throw NetworkException('No internet connection');
      } catch (e) {
        if (e is AuthenticationException) {
          log('❌ PUT Auth Exception: $e');
          throw e;
        }
        if (e is ApiException) {
          if (e.toString().contains('Server error') && retryCount < maxRetries) {
            log('⚠️ Server error exception, retrying in 1 second... (Attempt ${retryCount + 1}/${maxRetries + 1})');
            await Future.delayed(const Duration(seconds: 1));
            retryCount++;
            continue;
          }
          throw e;
        }

        log('❌ PUT Exception: $e');
        throw ApiException('Unexpected error during PUT');
      }
    }

    throw ApiException('Failed after all retry attempts');
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
        case 201:
        return jsonDecode(response.body);
      case 400:
        throw ApiException('Bad Request ${handleErrorResp(response.body, '')}');
      case 404:
        throw ApiException('Page not found (404). Please contact admin');
      case 401:
        throw ApiException('Unauthorized ${handleErrorResp(response.body, '')}');
      case 500:
        // Handle specific server errors
        final errorMessage = handleErrorResp(response.body, 'Internal Server Error');
        if (errorMessage.contains('Transaction cannot be rolled back') || 
            errorMessage.contains('database') ||
            errorMessage.contains('transaction')) {
          throw ApiException('Server is temporarily unavailable. Please try again in a few moments.');
        } else {
          throw ApiException('Server error: $errorMessage');
        }
      case 502:
        throw ApiException('Bad Gateway ${handleErrorResp(response.body, '')}');
      case 503:
        throw ApiException('Service temporarily unavailable. Please try again later.');
      case 504:
        throw ApiException('Gateway timeout. Please try again.');
      case 408:
        throw ApiException('Request Timeout: Please try again later');
      default:
        if (response.statusCode >= 500) {
          throw ApiException('Server error (${response.statusCode}). Please try again later.');
        } else {
          throw ApiException('Unexpected error ${response.statusCode} \n ${handleErrorResp(response.body, '')}');
        }
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
    final refreshToken = await storageService.getString(AppConstants.prefRefreshToken);
    if (refreshToken == null || refreshToken.isEmpty) {
      log('⚠️ No refresh token found.');
      // Clear stored tokens and redirect to login
      await _clearStoredTokens();
      return false;
    }

    final Uri url = Uri.parse('$_baseUrl/auth/refresh-token');
    int retryCount = 0;
    const maxRetries = 2;

    while (retryCount <= maxRetries) {
      try {
        log('🔄 Refreshing token... (Attempt ${retryCount + 1}/${maxRetries + 1})');
        log('🔸 Refresh Token: ${refreshToken.substring(0, 10)}...'); // Log only first 10 chars for security

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': refreshToken}),
        );
        log('🔸 Post Request to: $url');

        log('📩 Refresh Response Status: ${response.statusCode}');
        log('📩 Refresh Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          
          // Handle different possible response structures
          String? newAccessToken;
          String? newRefreshToken;
          
          if (json['data'] != null) {
            newAccessToken = json['data']['accessToken'];
            newRefreshToken = json['data']['refreshToken'];
          } else if (json['accessToken'] != null) {
            newAccessToken = json['accessToken'];
            newRefreshToken = json['refreshToken'];
          }
          
          if (newAccessToken != null && newAccessToken.isNotEmpty) {
            await storageService.saveString(AppConstants.prefAccessToken, newAccessToken);
            if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
              await storageService.saveString(AppConstants.prefRefreshToken, newRefreshToken);
            }
            log('✅ Token refreshed successfully');
            return true;
          } else {
            log('❌ Invalid response structure for token refresh');
            await _clearStoredTokens();
            return false;
          }
        } else if (response.statusCode == 401) {
          log('❌ Refresh token is invalid or expired');
          await _clearStoredTokens();
          return false;
        } else if (response.statusCode >= 500 && retryCount < maxRetries) {
          // Server error, retry after delay
          log('⚠️ Server error (${response.statusCode}), retrying in 1 second...');
          await Future.delayed(const Duration(seconds: 1));
          retryCount++;
          continue;
        } else {
          log('❌ Failed to refresh token: ${response.body}');
          return false;
        }
      } catch (e) {
        if (retryCount < maxRetries) {
          log('⚠️ Refresh token exception (attempt ${retryCount + 1}), retrying in 1 second...: $e');
          await Future.delayed(const Duration(seconds: 1));
          retryCount++;
          continue;
        } else {
          log('❌ Refresh token exception after all retries: $e');
          return false;
        }
      }
    }
    
    return false;
  }

  Future<void> _clearStoredTokens() async {
    await storageService.clearAll();
    log('🗑️ Cleared all stored preferences due to auth failure');
  }


  Future<void> logout() async {
    await _clearStoredTokens();
    log('👋 User logged out successfully');
  }
}
