import 'package:aesthetic_clinic/models/verify_otp_response.dart';
import 'package:aesthetic_clinic/providers/authentication_provider.dart';
import 'package:aesthetic_clinic/utils/toast_helper.dart';
import 'package:aesthetic_clinic/views/profile_screens/personalise_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../services/ui_state.dart';
import '../../utils/Appcolor.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final int otpLength = 6;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String otpValue = '';

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(otpLength, (_) => FocusNode());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      provider.startTimer();
      _focusNodes[0].requestFocus();
    });

  }

  void _onOtpChanged() {
    setState(() {
      otpValue = _controllers.map((c) => c.text).join();
    });

    if (otpValue.length == otpLength) {
      final provider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );

      final phoneNumber = provider.formatPhoneNumber(
        provider.selectedCountry.phoneCode,
        provider.phoneController.text,
      );

      provider.verifyOtp(phoneNumber, otpValue);
    }
  }


  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 45,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          counterText: "",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index + 1 < otpLength) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else {
              FocusScope.of(context).unfocus();
            }
          } else {
            if (index > 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          }
          _onOtpChanged();
        },
        onTap: () async {
          final data = await Clipboard.getData("text/plain");
          if (data != null && data.text != null) {
            final pasted = data.text!.trim();
            if (pasted.length == otpLength) {
              for (int i = 0; i < otpLength; i++) {
                _controllers[i].text = pasted[i];
              }
              _onOtpChanged(); // auto verify
            }
          }
        },
      ),
    );
  }

  void _onResend() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      provider.startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.verifyMsg),
        centerTitle: true,
      ),
      body: Consumer<AuthenticationProvider>(
        builder: (context, provider, child) {
          final state = provider.verifyOtpState;

          if (state is Success<VerifyOtpResponseModel>) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => PersonalizeScreen(isVerified: true),
                ),
              );
            });
          }

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(
                              color: Colors.grey.shade400,
                              thickness: 1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            localization.verifyCodeMsg,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
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

                          // ✅ Custom OTP input (6 fields)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              otpLength,
                                  (index) => _buildOtpField(index),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            provider.canResend
                                ? localization.resendNow
                                : "${localization.resendInTime} : ${provider.start.toString().padLeft(2, '0')}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 16),

                          ElevatedButton(
                            onPressed: provider.canResend ? _onResend : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25D366),
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
                                provider.sendOtp(
                                  provider.selectedCountry.phoneCode +
                                      provider.phoneController.text,
                                );
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
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // Bottom section
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
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: otpValue.length == otpLength
                                  ? () async {
                                final phoneNumber =
                                provider.formatPhoneNumber(
                                  provider.selectedCountry.phoneCode,
                                  provider.phoneController.text,
                                );
                                await provider.verifyOtp(phoneNumber, otpValue);
                              }:null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Appcolor.mehrun,
                                padding:
                                const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                localization.verify,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              if (state is Loading)
                Container(
                  color: Colors.black26,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
