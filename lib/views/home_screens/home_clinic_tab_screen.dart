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
import '../../utils/Appcolor.dart';
import '../booking_screens/booking_tab_screen.dart';
import '../profile_screens/profile_screen.dart';
import '../service_screens/service_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalStorageService storage = LocalStorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          return DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header + Search + Banner
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/icons/ic_logo_new.png',
                              height: 40,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _getGreeting(),
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "${storage.getString(AppConstants.prefFirstName)??"your"} ${storage.getString(AppConstants.prefLastName)??"name"}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Appcolor.mehrun,
                                    fontSize: 17,
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
                            SizedBox(
                              width: 8,
                            ),
                            CartIconButton(itemCount: 0, onPressed: () {}),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // TabBar (full width, no white spaces)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11), // Slightly smaller to fit inside border
                      child: TabBar(
                        padding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        indicatorPadding: EdgeInsets.zero,
                        indicator: BoxDecoration(
                          color: Appcolor.mehrun,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey[600],
                        dividerColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        tabs: [
                          Tab(
                            child: Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ImageIcon(
                                    AssetImage('assets/icons/ic_tab_clinic.png'),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Clinic Based',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ImageIcon(
                                    AssetImage('assets/icons/ic_tab_home.png'),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Home Based',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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

  if (hour < 12) {
    return ' ☀️ Good Morning'; // Sun emoji
  } else if (hour < 17) {
    return ' 🌤️ Good Afternoon'; // Afternoon / partly sunny
  } else {
    return ' 🌙  Goon Evening'; // Moon emoji
  }
}
