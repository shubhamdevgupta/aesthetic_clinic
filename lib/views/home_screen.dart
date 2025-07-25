import 'dart:async';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Top App Bar with Logo and Name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/icons/amara_logo.png', height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_getGreeting(), style: const TextStyle(fontSize: 14)),
                    const Text("Samiya Fatima",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                          fontSize: 16,
                        )),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search / Drawer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.menu),
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
            const AutoScrollingBanner(),
            const SizedBox(height: 24),

            // Our Top Services
            const Text(
              "Our Top Services",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  ServiceItem(icon: Icons.lightbulb, label: "Laser Hair Removal"),
                  ServiceItem(icon: Icons.face, label: "Dermatology"),
                  ServiceItem(icon: Icons.medical_services, label: "Dental Services"),
                  ServiceItem(icon: Icons.healing, label: "Hijama Therapy"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Our Top Choices for You
            const Text(
              "Our Top Choices for You",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  topChoiceItem("Injectables",
                      "https://images.pexels.com/photos/5863396/pexels-photo-5863396.jpeg"),
                  topChoiceItem("Skin Tightening",
                      "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg"),
                  topChoiceItem("Deep Cleansing",
                      "https://images.pexels.com/photos/3997985/pexels-photo-3997985.jpeg"),
                ],
              ),
            ),
          ],
        ),
      ),
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
            child: Image.network(imageUrl,
                height: 120, width: 140, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class ServiceItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const ServiceItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.pink.shade50,
            child: Icon(icon, color: Colors.pink),
          ),
          const SizedBox(height: 6),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class AutoScrollingBanner extends StatefulWidget {
  const AutoScrollingBanner({super.key});

  @override
  State<AutoScrollingBanner> createState() => _AutoScrollingBannerState();
}

class _AutoScrollingBannerState extends State<AutoScrollingBanner> {
  final PageController _pageController = PageController();
  final List<String> images = [
    'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
    'https://images.pexels.com/photos/3997985/pexels-photo-3997985.jpeg',
    'https://images.pexels.com/photos/1612985/pexels-photo-1612985.jpeg',
  ];

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), autoScroll);
  }

  void autoScroll() {
    if (!mounted) return;

    currentPage = (currentPage + 1) % images.length;

    _pageController.animateToPage(
      currentPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(seconds: 3), autoScroll);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "10% off on Derma",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      "App Only Offer",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.pink,
                  ),
                  child: const Text("Book Now"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
