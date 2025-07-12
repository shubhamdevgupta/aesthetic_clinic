import 'package:aesthetic_clinic/providers/authentication_provider.dart';
import 'package:aesthetic_clinic/utils/toast_helper.dart';
import 'package:aesthetic_clinic/views/auth/verify_otp_screen.dart';
import 'package:aesthetic_clinic/views/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';
import '../onboarding/onboarding_screen.dart';
import 'country_selection_screen.dart'; // ⬅️ You'll create this file

class SendOtpScreen extends StatefulWidget {
  const SendOtpScreen({super.key});

  @override
  State<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<SendOtpScreen> {
  Country _selectedCountry = Country(
    phoneCode: '971',
    countryCode: 'AED',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'United Arab Emirates',
    example: '2015550123',
    displayName: 'United Arab Emirates',
    displayNameNoCountryCode: 'United Arab Emirates',
    e164Key: '',
  );

  Future<void> _navigateToCountryPicker() async {
    final selected = await Navigator.push<Country>(
      context,
      MaterialPageRoute(builder: (_) => const CountrySelectionScreen()),
    );

    if (selected != null) {
      setState(() {
        _selectedCountry = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
        title: Text(
          "Login or Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<AuthenticationProvider>(
        builder: (context, provider, child) {
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
                          child: GestureDetector(
                            onTap: _navigateToCountryPicker,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                              child: Row(
                                children: [
                                  Text(
                                    _selectedCountry.flagEmoji,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      "+${_selectedCountry.phoneCode}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down, size: 20),
                                ],
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
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12),
                              labelText: 'Mobile Number',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Spacer(),

                  Center(child: Text('We will whatsapp you to confirm your number',style: TextStyle(fontSize: 12,color: Colors.grey.shade600)),),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final phoneNumber =
                              '+${_selectedCountry.phoneCode}${provider.phoneController.text}';
                          print('Send OTP to $phoneNumber');
                          if (provider.phoneController.text.isNotEmpty) {
                            provider.phoneController.text = phoneNumber;
                            await provider.sendOtp(phoneNumber);
                          }else{
                            ToastHelper.showErrorSnackBar(context, 'Please enter valid mobile number');
                          }
                          provider.otpResponse!.message ==
                                  "OTP sent to your phone via WhatsApp"
                              ? Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const OtpVerificationScreen(),
                                  ),
                                )
                              : ToastHelper.showErrorSnackBar(
                                  context,
                                  "Error in api : ${provider.otpResponse!.message}",
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
                          'Send OTP',
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
