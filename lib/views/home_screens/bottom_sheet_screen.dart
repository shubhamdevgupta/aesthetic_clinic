import 'package:aesthetic_clinic/views/profile_screens/profile_screen.dart';
import 'package:aesthetic_clinic/views/service_screens/service_details.dart';
import 'package:aesthetic_clinic/views/service_screens/service_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/Appcolor.dart';
import '../booking_screens/booking_screen.dart';
import 'home_clinic_tab_screen.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ServiceScreen(),
    BookingScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, -4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/icons/bg_bottoms.png',
                  fit: BoxFit.fill,
                ),
              ),
              BottomNavigationBar(
                currentIndex: _currentIndex,
                selectedItemColor: Appcolor.mehrun,
                unselectedItemColor: Colors.grey,
                backgroundColor: Colors.transparent,
                elevation: 0,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/icons/ic_home.png', width: 48,height: 48,),
                    activeIcon: Image.asset('assets/icons/ic_home_highlight.png', width: 48,height: 48,),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/icons/ic_service.png', width: 48,height: 48,),
                    activeIcon: Image.asset('assets/icons/ic_service_highlight.png', width: 48,height: 48,),
                    label: 'Services',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/icons/ic_booking.png', width: 48,height: 48,),
                    activeIcon: Image.asset('assets/icons/ic_booking_highlight.png', width: 48,height: 48,),
                    label: 'Bookings',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/icons/ic_profile.png', width: 48,height: 48,),
                    activeIcon: Image.asset('assets/icons/ic_profile_highlight.png', width: 48,height: 48,),
                    label: 'Profile',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
