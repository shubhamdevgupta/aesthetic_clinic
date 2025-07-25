import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    // Auto-scroll
    Future.delayed(const Duration(seconds: 3), autoScroll);
  }

  void autoScroll() {
    if (!mounted) return;

    currentPage++;
    if (currentPage >= images.length) currentPage = 0;

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
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      images[index],
                      fit: BoxFit.cover,
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text("App Only Offer",
                            style:
                            TextStyle(color: Colors.white70, fontSize: 12)),
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
        ],
      ),
    );
  }
}
