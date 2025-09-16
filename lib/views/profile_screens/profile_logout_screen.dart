import 'package:aesthetic_clinic/views/profile_screens/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/Appcolor.dart';
import 'get_help_screen.dart';

class ProfileLogoutScreen extends StatelessWidget {
  const ProfileLogoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageSize = screenWidth * 0.55;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, // 5% padding
              ),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.07), // instead of 60

                  /// Profile Image
                  Center(
                    child: Image.asset(
                      'assets/icons/ic_skin_booking.png',
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05), // instead of 40

                  /// Login/Signup Text
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: screenWidth * 0.035, // dynamic font size
                        color: Colors.grey[600],
                      ),
                      children: const [
                        TextSpan(text: 'Please '),
                        TextSpan(
                          text: 'Log in',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(text: ' or '),
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(text: ' to view your profile.'),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03), // instead of 28

                  /// Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        print('Log In pressed');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B2D5C),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02, // responsive
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Log In / Sign Up',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.07), // instead of 60

                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Get Help',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GetHelpScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: screenHeight * 0.05), // instead of 40

                  /// Footer Links (Responsive)
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: screenWidth * 0.05, // gap between items
                    runSpacing: 8, // gap when wrapping
                    children: [
                      _buildFooterLink('FAQs', () {}),
                      _buildFooterLink('Privacy Policy', () {}),
                      _buildFooterLink('Terms & Conditions', () {}),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  /// App Version
                  Text(
                    'App Version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: screenWidth * 0.03,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// (your _buildMenuItem and _buildFooterLink remain same)



Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool hasBadge = false,
    int badgeCount = 0,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: Stack(
          children: [
            Icon(
              icon,
              color:  Appcolor.mehrun,
              size: 24,
            ),
            if (hasBadge)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildFooterLink(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: TextStyle(
            color:  Appcolor.mehrun,
            fontSize: 14,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
