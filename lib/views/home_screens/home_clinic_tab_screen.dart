import 'dart:async';

import 'package:aesthetic_clinic/providers/authentication_provider.dart';
import 'package:aesthetic_clinic/providers/home_provider.dart';
import 'package:aesthetic_clinic/utils/AppConstants.dart';
import 'package:aesthetic_clinic/utils/widgets/AppDialog.dart';
import 'package:aesthetic_clinic/utils/widgets/CartIconButton.dart';
import 'package:aesthetic_clinic/views/home_screens/clinic_based_screen.dart';
import 'package:aesthetic_clinic/views/home_screens/home_based_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/LocalStorageService.dart';
import '../booking_screens/booking_screen.dart';
import '../profile_screens/profile_screen.dart';
import '../service_screens/service_screen.dart';
import 'auto_scroll_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalStorageService storage = LocalStorageService();

  @override
  void initState() {
    super.initState();
    Future.microtask(
          () =>
          Provider.of<HomeProvider>(context, listen: false).getDashboardData(),
    );
    print("userid--  ${storage.getString(AppConstants.prefUserId)}");
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
              colors: [
                const Color(0xFF660033),
                const Color(0xFF660033).withOpacity(0.8),
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${storage.getString(AppConstants.prefUserName)}',
                      style: const TextStyle(
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
              _buildDrawerItem(
                icon: Icons.home,
                title: 'Home',
                onTap: () => Navigator.pop(context),
              ),
              _buildDrawerItem(
                icon: Icons.person,
                title: 'Profile',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.calendar_month,
                title: 'Bookings',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const BookingScreen()),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.credit_card,
                title: 'Service',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => ServiceScreen()),
                  );
                },
              ),
              Divider(color: Colors.white.withOpacity(0.3), height: 32),
              _buildDrawerItem(
                icon: Icons.logout,
                title: 'Logout',
                onTap: (){
                  AppDialogs.showLogoutDialog(context);
                },
                isLogout: true,
              ),
            ],
          ),
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if (provider.appConfigResponse == null || provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final bannerList = provider.appConfigResponse!.data
              .expand((item) => item.appConfigs.banner)
              .toList();

          return DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header + Search + Banner
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/icons/amara_logo.png',
                              height: 40,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _getGreeting(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  '${storage.getString(AppConstants.prefUserName)}',
                                  style: const TextStyle(
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
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          Scaffold.of(context).openDrawer(),
                                      icon: const Icon(Icons.menu),
                                    ),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: "Search",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.search),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            CartIconButton(itemCount: 0, onPressed: () {}),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: AutoScrollingBanner(bannerList: bannerList),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // TabBar (real buttons look)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                        color: const Color(0xFF660033),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey[600],
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/ic_tab_clinic.png',
                                  height: 20),
                              const SizedBox(width: 6),
                              const Text('Clinic Based'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/ic_tab_home.png',
                                  height: 20),
                              const SizedBox(width: 6),
                              const Text('Home Based'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // TabBarView (Expanded to fill space)
                  const Expanded(
                    child: TabBarView(
                      children: [ClinicBasedScreen(), HomeBasedScreen()],
                    ),
                  ),
                ],
              ),
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
}

String _getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good Morning';
  if (hour < 17) return 'Good Afternoon';
  return 'Good Evening';
}
