import 'dart:async';

import 'package:aesthetic_clinic/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/LocalStorageService.dart';
import '../../utils/Appcolor.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ServiceScreen> {
  final LocalStorageService storage = LocalStorageService();

  @override
  void initState() {
    super.initState();
    Future.microtask(
          () =>
          Provider.of<ServiceProvider>(context, listen: false).getAllServices(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ServiceProvider>(
        builder: (context, provider, child) {
          if (provider.serviceResponse == null || provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // or a placeholder
          }
          final topServices = provider.serviceResponse!.data
              .where((item) => item.isTopService) // filter only top services
              .toList();

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 🔍 Search Bar
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
                const SizedBox(height: 16),
                const SizedBox(height: 16),

                // Main categories
                const Text(
                  "Our Main Categories",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Appcolor.mehrun,
                  ),
                ),
                const SizedBox(height: 12),

                // Horizontal top services
                SizedBox(
                  height: 80, // Increased height slightly to accommodate border/shadow
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: topServices.length,
                    itemBuilder: (context, index) {
                      final service = topServices[index];
                      final isSelected = provider.selectedService != null && service.id == provider.selectedService!.id;

                      return GestureDetector(
                        onTap: () {
                          provider.selectService(service);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Added vertical padding
                          margin: const EdgeInsets.only(right: 8), // Added margin for spacing
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.pink.withOpacity(0.1) : Colors.transparent, // Subtle background for selected
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? Colors.pink : Colors.grey[300]!,
                              width: isSelected ? 2.0 : 1.0,
                            ),
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: Colors.pink.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ]
                                : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, // Center items
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10), // Slightly smaller radius
                                child: Image.network(
                                  service.topServiceImage ?? service.image,
                                  width: 38, // Adjusted size
                                  height: 38, // Adjusted size
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                service.name,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? Colors.pink : Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Show subservices if selected
                if (provider.selectedService != null) ...[

                  if (provider.selectedService!.subServices.isNotEmpty)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: provider.selectedService!.subServices.length,
                      itemBuilder: (context, index) {
                        final subService = provider.selectedService!.subServices[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    subService.image,
                                    height: 70,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  subService.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                if (provider.selectedService!.doctors.isNotEmpty)
                                  Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: provider.selectedService!.doctors.length,
                                      itemBuilder: (context, docIndex) {
                                        final doc =
                                        provider.selectedService!.doctors[docIndex];
                                        return Text(
                                          "👨‍⚕️ ${doc.name}",
                                          style: const TextStyle(fontSize: 11),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  else
                    Visibility(
                      visible: false,
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/no_service.png", // dummy image
                            height: 120,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "No sub-services available",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          );
        },
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
            child: Image.network(
              imageUrl,
              height: 120,
              width: 140,
              fit: BoxFit.cover,
              // Downscale a bit to reduce decode cost
              cacheWidth: 560,
              cacheHeight: 480,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _ShimmerPlaceholder(
                  width: 140,
                  height: 120,
                  borderRadius: 12,
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                height: 120,
                width: 140,
                color: const Color(0xFFFFEBEE),
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image, color: Colors.red),
              ),
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

class _ShimmerPlaceholder extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerPlaceholder({
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<_ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<_ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1 + _controller.value * 2, 0),
              end: Alignment(1 + _controller.value * 2, 0),
              colors: const [
                Color(0xFFF1F1F1),
                Color(0xFFE7E7E7),
                Color(0xFFF1F1F1),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ServiceItem extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback onTap;

  const ServiceItem({
    Key? key,
    required this.imageUrl,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 60,
              child: Text(
                label,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
