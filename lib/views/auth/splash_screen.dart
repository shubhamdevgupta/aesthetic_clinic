import 'package:aesthetic_clinic/providers/authentication_provider.dart';
import 'package:aesthetic_clinic/services/LocalStorageService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/AppConstants.dart';
import '../../utils/Appcolor.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalStorageService storage = LocalStorageService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _navigateToNextScreen();
    });
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    
    // Check if user has seen onboarding
    final hasSeenOnboarding = storage.getBool(AppConstants.prefSeenOnboarding) ?? false;
    
    if (!hasSeenOnboarding) {
      // First time user - go to language selection
      Navigator.pushReplacementNamed(context, AppConstants.navigateToSelectLanguageScreen);
      return;
    }
    
    // Check authentication state using the provider
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.checkAuthenticationState();
    
    if (authProvider.isLoggedIn) {
      // User is logged in - go to dashboard
      Navigator.pushReplacementNamed(context, AppConstants.navigateToDashboardScreen);
    } else {
      // User is not logged in - go to login
      Navigator.pushReplacementNamed(context, AppConstants.navigateToSendOtpScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // Top part remains white
      body: Stack(
        children: [
          // Bottom U-shape container
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: screenWidth,
              height: screenHeight / 1.1,
              decoration: BoxDecoration(
                color: Appcolor.mehrun,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenWidth),
                  topRight: Radius.circular(screenWidth),
                ),
              ),
            ),
          ),

          // Centered icon on full screen
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Image.asset('assets/icons/ic_logo_new.png', width: 220)],
            ),
          ),
        ],
      ),
    );
  }
}
