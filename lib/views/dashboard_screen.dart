import 'package:aesthetic_clinic/views/profile_screen.dart';
import 'package:flutter/material.dart';

import 'booking_screen.dart';
import 'credit_screen.dart';
import 'home_screen.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    BookingScreen(),
    CreditScreen(),
    ProfileScreen(),
  ];

  final List<String> _titles = [
    'Home',
    'Bookings',
    'Credits',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex])),
      body: _screens[_currentIndex],
      bottomNavigationBar: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/icons/bg_bottoms.png', // your curved image path
              fit: BoxFit.fill,
            ),
          ),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items:  [
              BottomNavigationBarItem(
                icon: Icon(Icons.home,color: Color(0xFF660033),),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/ic_service.png',color: Color(0xFF660033),),
                label: 'Services',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month,color: Color(0xFF660033),),
                label: 'Bookings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person,color: Color(0xFF660033),),
                label: 'Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
