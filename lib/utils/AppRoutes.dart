import 'package:flutter/cupertino.dart';
import '../views/auth/LoginScreen.dart';
import '../views/auth/SplashScreen.dart';
import 'AppConstants.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      //auth
      AppConstants.navigateToLoginScreen: (context) => const Loginscreen(),
      '/': (context) => const SplashScreen(),

    };
  }
}
