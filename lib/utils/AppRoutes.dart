import 'package:aesthetic_clinic/views/auth/verify_otp_screen.dart';
import 'package:aesthetic_clinic/views/onboarding/language_screen.dart';
import 'package:aesthetic_clinic/views/onboarding/onboarding_screen.dart';
import 'package:flutter/cupertino.dart';
import '../views/auth/send_otp_screen.dart';
import '../views/auth/splash_screen.dart';
import 'AppConstants.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      //auth
      AppConstants.navigateToSendOtpScreen: (context) => const SendOtpScreen(),
      AppConstants.navigateToSplashScreen: (context) => const SplashScreen(),
      AppConstants.navigateToOnBoardingScreen:(context)=> const OnboardingScreen(),
      AppConstants.navigateToVerifyOtpScreen:(context)=> const OtpVerificationScreen(),
      AppConstants.navigateToSelectLanguageScreen:(context)=>  LanguageSelectionScreen()
    };
  }
}
