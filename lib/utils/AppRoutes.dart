import 'package:aesthetic_clinic/views/onboarding/onboarding_screen.dart';
import 'package:flutter/cupertino.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/splash_screen.dart';
import 'AppConstants.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      //auth
      AppConstants.navigateToLoginScreen: (context) => const LoginScreen(),
      AppConstants.navigateToSplashScreen: (context) => const SplashScreen(),
      AppConstants.navigateToOnBoardingScreen:(context)=> const OnboardingScreen()
    };
  }
}
