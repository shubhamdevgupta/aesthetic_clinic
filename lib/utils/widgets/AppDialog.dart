import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/authentication_provider.dart';
import '../AppConstants.dart';
import '../Appcolor.dart';


class AppDialogs {
  static Future<void> showLogoutDialog(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.logout, color: Appcolor.mehrun),
              const SizedBox(width: 8),
              const Text('Logout', style: TextStyle(color: Appcolor.mehrun)),
            ],
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor:  Appcolor.mehrun,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.logout();

      Navigator.pushReplacementNamed(
        context,
        AppConstants.navigateToSplashScreen,
      );
    }
  }
}
