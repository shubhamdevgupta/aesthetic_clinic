import 'dart:async';

import 'package:aesthetic_clinic/providers/authentication_provider.dart';
import 'package:aesthetic_clinic/utils/toast_helper.dart';
import 'package:aesthetic_clinic/views/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late Timer _timer;
  int _start = 30; // countdown duration
  bool _canResend = false;
  String? otpValue;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _start = 30;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onResend() {
    // Implement resend logic
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title:  Text(localization.verifyMsg),
      ),
      body: Consumer<AuthenticationProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(color: Colors.grey.shade400, thickness: 1),
                ),
                const SizedBox(height: 16),
                Text(
                 localization.verifyCodeMsg,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.phoneController.text,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF660033),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // OTP input
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    otpValue = value;
                  },
                  pinTheme: PinTheme(
                    activeColor: Color(0xFF660033),
                    inactiveColor: Colors.grey.shade700,
                    selectedColor: Color(0xFF660033),
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 40,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  _canResend
                      ? localization.resendNow
                      : "${localization.resendInTime} ${_start.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _canResend ? _onResend : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF25D366), // WhatsApp green
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/ic_whatsapp.png',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                       Text(
                        localization.whatsapp,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Verify Button
                Center(
                  child: Text(
                    localization.otpMsg,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (otpValue!.isNotEmpty) {
                          await provider.verifyOtp(
                            provider.phoneController.text,
                            otpValue!,
                          );
                        }
                        provider.authResponse!.data!.accessToken.isNotEmpty
                            ? Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const DashboardScreen(),
                                ),
                              )
                            : ToastHelper.showErrorSnackBar(
                                context,
                                "Error in api : ${provider.authResponse!.error}",
                              );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF660033),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        localization.verify,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
