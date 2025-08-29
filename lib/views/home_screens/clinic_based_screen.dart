import 'package:aesthetic_clinic/providers/home_provider.dart';
import 'package:aesthetic_clinic/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service_screens/service_details.dart';
import '../service_screens/service_popup.dart';

class ClinicBasedScreen extends StatefulWidget {
  const ClinicBasedScreen({super.key});

  @override
  State<ClinicBasedScreen> createState() => _ClinicBasedScreenState();
}

class _ClinicBasedScreenState extends State<ClinicBasedScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
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
        final recommendedProducts = provider.appConfigResponse!.data
            .expand((item) => item.recommendedProducts)
            .toList();
        final personalizeServices = provider.appConfigResponse!.data
            .expand((item) => item.personalisedServices)
            .toList();
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),

          children: [
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
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topServices.length,
                itemBuilder: (context, length) {
                  final service = topServices[length];
                  return ServiceItem(
                    imageUrl: service.topServiceImage!,
                    label: service.name,
                    serviceID: service.id,
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
                  final recommended = recommendedServices[length];
                  return topChoiceItem(
                    recommended.name,
                    recommended.description,
                    recommended.image,
                    context,
                  );
                },
              ),
            ),
            //
            const Text(
              "Get Our Trusted Products",
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
                itemCount: recommendedProducts.length,
                itemBuilder: (context, length) {
                  final personalize = recommendedProducts[length];
                  return topChoiceItem(
                    personalize.name,
                    personalize.description,
                    personalize.featuredImage,
                    context,
                  );
                },
              ),
            ),
            // Our Personalized service  for You
            const Text(
              "Our Personalise Services for You",
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
                itemCount: personalizeServices.length,
                itemBuilder: (context, length) {
                  final personalize = personalizeServices[length];
                  return topChoiceItem(
                    personalize.name,
                    personalize.description,
                    personalize.image,
                    context,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget topChoiceItem(
    String title,
    String description,
      String imageUrl,
      BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => ServicePopup(
            title: title,
            description:description,
            price: "200",
            duration: "30 Mins",
            imageUrl: imageUrl,
          ),
        );
      },
      child: Container(
        width: 160, // tweak as needed
        margin: const EdgeInsets.only(right: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background image
              Image.network(
                imageUrl,
                height: 200,
                width: 160,
                fit: BoxFit.cover,
                cacheWidth: 640,  // optional downscale
                cacheHeight: 800, // optional downscale
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _ShimmerPlaceholder(
                    width: 160,
                    height: 200,
                    borderRadius: 16,
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  width: 160,
                  color: const Color(0xFFFFEBEE),
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, color: Colors.red),
                ),
              ),

              // Your rectangle image at the bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/icons/ic_rectangle.png',
                  height: 64,          // adjust to match your asset
                  fit: BoxFit.fill,    // ensures full-width coverage
                ),
              ),

              // Text on top of the rectangle
              Positioned(
                left: 12,
                right: 12,
                bottom: 10, // sits nicely within the rectangle
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "55", // e.g., "Starting From AED100"
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
      ,

    );
  }
}

class ServiceItem extends StatelessWidget {
  final String imageUrl;
  final String label;
  final String serviceID;

  const ServiceItem({
    super.key,
    required this.imageUrl,
    required this.label,
    required this.serviceID,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailScreen(serviceId: serviceID),
          ),
        );
      },
      child: Container(
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
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF707070),
                  ),
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
                cacheWidth: 120,
                cacheHeight: 120,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _CircleShimmer(size: 40);
                },
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, color: Colors.red, size: 24),
              ),
            ),
          ],
        ),
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

class _CircleShimmer extends StatelessWidget {
  final double size;

  const _CircleShimmer({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(
        strokeWidth: 2,
        color: Color(0xFF660033),
      ),
    );
  }
}
