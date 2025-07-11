import 'package:aesthetic_clinic/services/LocalStorageService.dart';
import 'package:flutter/material.dart';

import '../../utils/AppConstants.dart';

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
      await Future.delayed(const Duration(seconds: 3)); // Optional splash delay
    print("seen on boarding ${storage.getBool(AppConstants.prefSeenOnboarding)}");
      if(storage.getBool(AppConstants.prefSeenOnboarding)??false){
        Navigator.pushReplacementNamed(context, AppConstants.navigateToSendOtpScreen);
      }else {
        Navigator.pushReplacementNamed(
            context, AppConstants.navigateToSelectLanguageScreen);
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
                color: Color(0xFF660033),
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
              children: [Image.asset('assets/icons/ic_logo.png', width: 220)],
            ),
          ),
        ],
      ),
    );
  }
}
