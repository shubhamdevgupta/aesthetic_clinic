import 'dart:ui';

import 'package:flutter/material.dart';

class LoaderUtils {
  /// Shows or hides a default loader dialog with optional message
  static void toggleLoadingDialog(BuildContext context, bool isLoading, {String? message}) {
    if (isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  if (message != null)
                    Text(
                      message,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'OpenSans',),
                    ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  /// Returns a conditional overlay loader
  static Widget conditionalLoader({required bool isLoading, Widget? child}) {
    if (!isLoading) {
      return child ?? const SizedBox.shrink();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Dim + blur the background
        Container(color: Colors.black.withOpacity(0.25)),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: const SizedBox.expand(),
        ),

        // Centered glass card with brand spinner
        Center(
          child: Container(
            width: 180,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    color: Color(0xFF660033),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Just a moment...',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Returns a reusable styled progress loader widget (for embedding in dialogs)
  static Widget showProgress() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const CircularProgressIndicator(),
      ),
    );
  }

  static void showCustomLoaderDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => showProgress(),
    );
  }

  static void hideLoaderDialog(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  //////////////////////////////////////////////////////////////

  /// Hides the loading dialog.
  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  /// Shows a loading dialog with an optional custom message.
  static void showLoadingWithMessage(
      BuildContext context, {
        String message = 'Loading...',
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black45, // semi-transparent background
      builder: (_) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );


  }


}
