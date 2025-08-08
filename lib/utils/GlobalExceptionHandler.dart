import 'package:aesthetic_clinic/utils/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/authentication_provider.dart';
import '../utils/AppConstants.dart';
import '../views/ExceptionScreen.dart';
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
        ToastHelper.showSnackBar(context, errorMessage);
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
      // Get the authentication provider and logout
      final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
      await authProvider.logout();
      
      // Show error message
      ToastHelper.showSnackBar(context, errorMessage);
      
      // Navigate to login screen
      if (navigatorKey.currentState != null) {
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          AppConstants.navigateToSendOtpScreen,
          (route) => false, // Remove all previous routes
        );
      }
    });
  }
}
