import 'package:aesthetic_clinic/services/LocalStorageService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/authentication_provider.dart';
import '../../utils/AppConstants.dart';
import '../../utils/UserSessionManager.dart';

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
    await Future.delayed(const Duration(seconds: 1)); // Optional splash delay
    print("seen on boarding ${storage.getBool(AppConstants.prefSeenOnboarding)}");
      if(storage.getBool(AppConstants.prefSeenOnboarding)??false){
        Navigator.pushReplacementNamed(context, AppConstants.navigateToLoginScreen);
      }else {
        Navigator.pushReplacementNamed(
            context, AppConstants.navigateToOnBoardingScreen);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Amara',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w400),),
            Text('Aesthetic Clinic',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w100),),
          ],
        ),
      ),
    );
  }
}
