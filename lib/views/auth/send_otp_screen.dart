import 'package:aesthetic_clinic/views/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'country_selection_screen.dart'; // ⬅️ You'll create this file

class SendOtpScreen extends StatefulWidget {
  const SendOtpScreen({super.key});

  @override
  State<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<SendOtpScreen> {
  Country _selectedCountry = Country(
    phoneCode: '1',
    countryCode: 'US',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'United States',
    example: '2015550123',
    displayName: 'United States',
    displayNameNoCountryCode: 'United States',
    e164Key: '',
  );

  final TextEditingController _phoneController = TextEditingController();

  Future<void> _navigateToCountryPicker() async {
    final selected = await Navigator.push<Country>(
      context,
      MaterialPageRoute(
        builder: (_) => const CountrySelectionScreen(),
      ),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Login or Sign Up",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Text(
                "Enter your mobile number, we will send you an OTP on Whatsapp",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  GestureDetector(
                    onTap: _navigateToCountryPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Text(_selectedCountry.flagEmoji, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text("+${_selectedCountry.phoneCode}"),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Mobile Number',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  final phoneNumber = '+${_selectedCountry.phoneCode}${_phoneController.text}';
                  print('Send OTP to $phoneNumber');
                  // TODO: Add your OTP logic
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const DashboardScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
