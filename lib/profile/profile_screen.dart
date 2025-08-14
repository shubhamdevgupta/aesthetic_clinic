import 'package:aesthetic_clinic/profile/settings_screen.dart';
import 'package:aesthetic_clinic/utils/AppConstants.dart';
import 'package:flutter/material.dart';

import '../../services/LocalStorageService.dart';
import 'get_help_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();

}

class _ProfileScreenState extends State<ProfileScreen> {
  final LocalStorageService storage = LocalStorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.person_add, color: Colors.black),
              onPressed: () {
                // Handle switch profile
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                 Text(
                  '${storage.getString(AppConstants.prefUserName)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Menu Options
            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'Personal Information',
              onTap: () {
                // Navigate to personal information
              },
            ),
            _buildMenuItem(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Payment Preferences',
              onTap: () {
                // Navigate to payment preferences
              },
            ),
            _buildMenuItem(
              icon: Icons.account_balance_outlined,
              title: 'Banks and Cards',
              onTap: () {
                // Navigate to banks and cards
              },
            ),
            _buildMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () {
                // Navigate to notifications
              },
            ),
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

            const SizedBox(height: 32),

            // Footer Links
            _buildFooterLink('FAQs', () {
              // Navigate to FAQs
            }),
            _buildFooterLink('Privacy Policy', () {
              // Navigate to privacy policy
            }),
            _buildFooterLink('Terms & Conditions', () {
              // Navigate to terms & conditions
            }),

            const SizedBox(height: 16),

            // App Version
            Center(
              child: Text(
                'App Version 1.0.0',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

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
              color: const Color(0xFF660033),
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
            color: const Color(0xFF660033),
            fontSize: 14,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
