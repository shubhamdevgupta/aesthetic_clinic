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

    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    final roleId = session.roleId;
    await authProvider.checkLoginStatus();

    if (authProvider.isLoggedIn) {
      if (roleId == 4) {
        Navigator.pushReplacementNamed(
            context, AppConstants.navigateToDashboardScreen);
      } else if (roleId == 8) {
        Navigator.pushReplacementNamed(
            context, AppConstants.navigateToDwsmDashboard);
      } else if (roleId == 7) {
        Navigator.pushReplacementNamed(
            context, AppConstants.navigateToFtkDashboard);
      }
    } else {
      Navigator.pushReplacementNamed(
          context, AppConstants.navigateToLoginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/wqmis_splash.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
