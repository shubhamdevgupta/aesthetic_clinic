import 'package:aesthetic_clinic/services/LocalStorageService.dart';
import 'package:aesthetic_clinic/utils/AppConstants.dart';
import 'package:aesthetic_clinic/views/auth/send_otp_screen.dart';
import 'package:aesthetic_clinic/views/dashboard_screen.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final LocalStorageService storage = LocalStorageService();

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xFFE9B6B3), Color(0xFFD1778A)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Spacer(),
                Image.asset('assets/icons/ic_welcome.png'),
                const SizedBox(height: 30),

                Image.asset('assets/icons/ic_face.png'),

                Center(
                  child: Text(
                    "Amara Welcome you to the personalised...",
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
                      onPressed: () {
                        storage.saveBool(AppConstants.prefSeenOnboarding, true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DashboardScreen(),
                          ),
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
                        "Let's get started",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*//todo make it true for one time see onboarding screen
storage.saveBool(AppConstants.prefSeenOnboarding, false);
Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (_) => const SendOtpScreen()),
);*/
