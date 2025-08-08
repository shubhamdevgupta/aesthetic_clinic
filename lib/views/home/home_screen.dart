import 'dart:async';

import 'package:aesthetic_clinic/providers/authentication_provider.dart';
import 'package:aesthetic_clinic/providers/service_provider.dart';
import 'package:aesthetic_clinic/utils/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auto_scroll_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<ServiceProvider>(context, listen: false).getBannerList(),
    );
  }

  void _handleLogout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Color(0xFF660033)),
              SizedBox(width: 8),
              Text('Logout', style: TextStyle(color: Color(0xFF660033))),
            ],
          ),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF660033),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      // Perform logout
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.logout();

      // Navigate to login screen
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppConstants.navigateToSendOtpScreen,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF660033), Color(0xFF660033).withOpacity(0.8)],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Drawer header
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Samiya Fatima',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Drawer items
              _buildDrawerItem(
                icon: Icons.home,
                title: 'Home',
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              _buildDrawerItem(
                icon: Icons.person,
                title: 'Profile',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to profile
                },
              ),

              _buildDrawerItem(
                icon: Icons.calendar_month,
                title: 'Bookings',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to bookings
                },
              ),

              _buildDrawerItem(
                icon: Icons.credit_card,
                title: 'Credits',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to credits
                },
              ),

              Divider(color: Colors.white.withOpacity(0.3), height: 32),

              // Logout item
              _buildDrawerItem(
                icon: Icons.logout,
                title: 'Logout',
                onTap: _handleLogout,
                isLogout: true,
              ),
            ],
          ),
        ),
      ),
      body: Consumer<ServiceProvider>(
        builder: (context, provider, child) {
          if (provider.appConfigResponse == null || provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // or a placeholder
          }
          final topServices = provider.appConfigResponse!.data
              .expand((item) => item.topServices)
              .toList();
          final recommendedServices = provider.appConfigResponse!.data
              .expand((item) => item.recommendedServices)
              .toList();
          final bannerList = provider.appConfigResponse!.data
              .expand((item) => item.appConfigs.banner)
              .toList();

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/icons/amara_logo.png', height: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _getGreeting(),
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Text(
                          "Samiya Fatima",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF660033),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Search Bar (Original)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: Icon(Icons.menu),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Icon(Icons.search),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Auto Scrolling Banner
                AutoScrollingBanner(bannerList: bannerList),
                const SizedBox(height: 24),

                // Our Top Services
                const Text(
                  "Our Top Services",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF660033),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 128,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: topServices.length,
                    itemBuilder: (context, length) {
                      final service = topServices[length];
                      return ServiceItem(
                        imageUrl: service.topServiceImage,
                        label: service.name,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Our Top Choices for You
                const Text(
                  "Our Top Choices for You",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF660033),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recommendedServices.length,
                    itemBuilder: (context, length) {
                      print("*******    $recommendedServices");
                      final recommended = recommendedServices[length];
                      return topChoiceItem(recommended.name, recommended.image);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red[300] : Colors.white,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red[300] : Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      tileColor: Colors.transparent,
      hoverColor: Colors.white.withOpacity(0.1),
    );
  }

  static Widget topChoiceItem(String title, String imageUrl) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 120,
              width: 140,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class ServiceItem extends StatelessWidget {
  final String imageUrl;
  final String label;

  const ServiceItem({super.key, required this.imageUrl, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Label at the top
          SizedBox(
            height: 30,
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Color(0xFF707070)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          const SizedBox(height: 10), // Space between label and image
          // Network image (circular)
          ClipOval(
            child: Image.network(
              imageUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, color: Colors.red, size: 24),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 40,
                  height: 40,
                  color: const Color(0xFFFFEBEE),
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      color: Color(0xFF660033),
                      size: 20,
                    ),
                  ),
                );
              },
            ),
          ),

          // Asset image directly below (no gap)
          Image.asset(
            'assets/icons/ic_below_service.png',
            width: 48,
            height: 48,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

String _getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good Morning';
  if (hour < 17) return 'Good Afternoon';
  return 'Good Evening';
}
