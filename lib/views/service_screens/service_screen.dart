import 'dart:async';

import 'package:aesthetic_clinic/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/all_services.dart';
import '../../services/LocalStorageService.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ServiceScreen> {
  final LocalStorageService storage = LocalStorageService();
  Service? selectedService;

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
          final subService = provider.serviceResponse!.data
              .where(
                (item) => item.parentServiceId != null,
              ) // filter only top services
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
                const SizedBox(height: 16),

                // Main categories
                const Text(
                  "Our Main Categories",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF660033),
                  ),
                ),
                const SizedBox(height: 12),

                // Horizontal top services
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: topServices.length,
                    itemBuilder: (context, index) {
                      final service = topServices[index];
                      return ServiceItem(
                        imageUrl: service.topServiceImage ?? service.image,
                        label: service.name,
                        onTap: () {
                          setState(() {
                            selectedService = service;
                          });
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Show subservices if selected
                if (selectedService != null) ...[
                  Text(
                    "${selectedService!.name} → Sub Services",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (selectedService!.subServices.isNotEmpty)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.9,
                          ),
                      itemCount: selectedService!.subServices.length,
                      itemBuilder: (context, index) {
                        final subService = selectedService!.subServices[index];
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

                                // Show doctors
                                if (selectedService!.doctors.isNotEmpty)
                                  Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          selectedService!.doctors.length,
                                      itemBuilder: (context, docIndex) {
                                        final doc =
                                            selectedService!.doctors[docIndex];
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
                    Column(
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
