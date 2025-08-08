import 'dart:ui';

import 'package:aesthetic_clinic/providers/authentication_provider.dart';
import 'package:aesthetic_clinic/utils/toast_helper.dart';
import 'package:aesthetic_clinic/views/auth/verify_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/LoaderUtils.dart';
import '../onboarding/onboarding_screen.dart';
import 'country_selection_screen.dart';

class SendOtpScreen extends StatefulWidget {
  const SendOtpScreen({super.key});

  @override
  State<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<SendOtpScreen> {
  bool _isNavigating = false;

  Future<void> _navigateToCountryPicker(BuildContext context, AuthenticationProvider provider) async {
    // Prevent multiple taps
    if (_isNavigating) return;
    
    setState(() {
      _isNavigating = true;
    });

    try {
      final selected = await Navigator.push<Country>(
        context,
        MaterialPageRoute(builder: (_) => const CountrySelectionScreen()),
      );

      if (selected != null) {
        provider.setSelectedCountry(selected);
      }
    } finally {
      setState(() {
        _isNavigating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
              localization.loginSignup,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Consumer<AuthenticationProvider>(
        builder: (context, provider, child) {
          if(provider.isLoading)return LoaderUtils.conditionalLoader(isLoading: provider.isLoading);
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(color: Colors.grey.shade400, thickness: 1),
                  ),
                  SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 3, // Around 30%
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _isNavigating ? null : () => _navigateToCountryPicker(context, provider),
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      provider.selectedCountry.flagEmoji,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        "+${provider.selectedCountry.phoneCode}",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size: 20,
                                      color: _isNavigating ? Colors.grey : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 48,
                          width: 1,
                          color: Colors.grey,
                        ),
                        Flexible(
                          flex: 7, // Around 70%
                          child: TextField(
                            controller: provider.phoneController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            onChanged: (value) {
                              // Clear error when user starts typing
                              if (provider.errorMsg.isNotEmpty) {
                                provider.clearError();
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              labelText: localization.mobileNumber,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Spacer(),

                  Center(child: Text(localization.sendOtpMsg,style: TextStyle(fontSize: 12,color: Colors.grey.shade600)),),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final rawPhone = provider.phoneController.text.trim();
                          final phoneNumber = provider.formatPhoneNumber(
                            provider.selectedCountry.phoneCode, 
                            rawPhone
                          );

                          final success = await provider.sendOtpWithValidation(phoneNumber);
                          
                          if (success) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const OtpVerificationScreen()),
                            );
                          } else {
                            ToastHelper.showErrorSnackBar(
                              context,
                              provider.errorMsg,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF660033),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          localization.sendOtp,
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
