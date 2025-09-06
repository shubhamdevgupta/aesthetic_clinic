import 'dart:async';

import 'package:aesthetic_clinic/providers/authentication_provider.dart';
import 'package:aesthetic_clinic/utils/toast_helper.dart';
import 'package:aesthetic_clinic/views/profile_screens/personalise_screen.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/Appcolor.dart';
import '../../utils/LoaderUtils.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late Timer _timer;
  int _start = 30; // countdown duration
  bool _canResend = false;
  String otpValue = '';

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
        title: Text(localization.verifyMsg),
      ),
      body: Consumer<AuthenticationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return LoaderUtils.conditionalLoader(isLoading: provider.isLoading);

          return Column(
            children: [
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
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
                        "${provider.selectedCountry.phoneCode}${provider.phoneController.text}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Appcolor.mehrun,
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
                          // Clear error when user starts typing
                          if (provider.errorMsg.isNotEmpty) {
                            provider.clearError();
                          }
                        },
                        pinTheme: PinTheme(
                          activeColor: Appcolor.mehrun,
                          inactiveColor: Colors.grey.shade700,
                          selectedColor: Appcolor.mehrun,
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
                          backgroundColor: const Color(0xFF25D366), // WhatsApp green
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            ToastHelper.showToastMessage("Sending otp..");
                            provider.sendOtp(provider.selectedCountry.phoneCode + provider.phoneController.text);
                          },
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
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Add some bottom padding to ensure content doesn't get cut off
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Fixed bottom section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localization.otpMsg,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final phoneNumber = provider.formatPhoneNumber(
                                provider.selectedCountry.phoneCode,
                                provider.phoneController.text
                            );

                            final success = await provider.verifyOtpWithValidation(phoneNumber, otpValue);

                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PersonalizeScreen(isVerified: true),
                                ),
                              );
                            } else {
                              ToastHelper.showErrorSnackBar(
                                context,
                                provider.errorMsg,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Appcolor.mehrun,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            localization.verify,
                            style: const TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}