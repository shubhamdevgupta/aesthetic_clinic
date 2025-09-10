import 'package:aesthetic_clinic/utils/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../main.dart';
import '../providers/authentication_provider.dart';
import '../utils/AppConstants.dart';
import '../views/auth/ExceptionScreen.dart';
import 'CustomException.dart';

class GlobalExceptionHandler {
  static void handleException(Exception e) {
    if (navigatorKey.currentContext == null) {
      debugPrint("Navigator key context is null, cannot show error.");
      return;
    }

    BuildContext context = navigatorKey.currentContext!;
    String errorMessage;

    if (e is AuthenticationException) {
      errorMessage = e.toString();
      _handleAuthenticationFailure(context, errorMessage);
      return;
    } else if (e is NetworkException) {
      errorMessage = e.toString();
    } else if (e is ApiException) {
      errorMessage = e.toString();
    } else {
      errorMessage = 'Unexpected Error Occurred \n$e';
    }

    debugPrint("Error Handled: $errorMessage");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (e is NetworkException) {
        if (navigatorKey.currentState?.canPop() == true) {
          navigatorKey.currentState?.pop();
        }
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              contentPadding: const EdgeInsets.all(16),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, color: Colors.redAccent, size: 56),
                  const SizedBox(height: 12),
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final connectivity = await Connectivity().checkConnectivity();
                        if (connectivity == ConnectivityResult.none) {
                          ToastHelper.showSnackBar(context, 'No internet connection');
                          return;
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text('Retry'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        // Full-screen error for API or unexpected errors
        if (navigatorKey.currentState?.canPop() == true) {
          navigatorKey.currentState?.pop();
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            contentPadding: EdgeInsets.zero, // Remove default padding
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: ExceptionScreen(errorMessage: errorMessage),
            ),
          ),
        );
      }
    });
  }

  static void _handleAuthenticationFailure(BuildContext context, String errorMessage) {
    debugPrint("Authentication failure handled: $errorMessage");
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Clear all persisted data via provider (central place)
      final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
      await authProvider.logout(context);
      
      // Show standardized unauthorized message
      const String unauthorizedMessage = 'Not authorized. Please login again.';
      ToastHelper.showSnackBar(context, unauthorizedMessage);
      
      // Navigate to Send OTP (login) and clear back stack
      if (navigatorKey.currentState != null) {
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          AppConstants.navigateToSendOtpScreen,
          (route) => false, // Remove all previous routes
        );
      }
    });
  }
}
