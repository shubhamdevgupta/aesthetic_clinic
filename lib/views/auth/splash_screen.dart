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
  final session = UserSessionManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await session.sanitizePrefs();  // await clear
      await session.init();       // await init after clearing
      _navigateToNextScreen();
    });
  }



  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 1)); // Optional splash delay

      Navigator.pushReplacementNamed(context, AppConstants.navigateToOnBoardingScreen);

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
