import 'package:aesthetic_clinic/utils/Appcolor.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AutoScrollingBanner extends StatefulWidget {
  final List<dynamic> items; // String URLs or objects with fields
  final double height;
  final Duration autoScrollDelay;
  final Widget? onEmpty;

  const AutoScrollingBanner({
    super.key,
    required this.items,
    this.height = 180,
    this.autoScrollDelay = const Duration(seconds: 3),
    this.onEmpty,
  });

  @override
  State<AutoScrollingBanner> createState() => _AutoScrollingBannerState();
}

class _AutoScrollingBannerState extends State<AutoScrollingBanner> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    if (widget.items.isNotEmpty) {
      Future.delayed(widget.autoScrollDelay, autoScroll);
    }

    // Fake shimmer loading for 2s
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void autoScroll() {
    if (!mounted || widget.items.isEmpty) return;

    final nextPage = (currentPage + 1) % widget.items.length;

    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
    );

    // 🔁 schedule next auto-scroll
    Future.delayed(widget.autoScrollDelay, autoScroll);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return widget.onEmpty ??
          SizedBox(
            height: widget.height,
            child: const Center(child: Text("No banners available")),
          );
    }

    return _isLoading
        ? _buildShimmerLoader()
        : Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = widget.items[index];

              String imageUrl = "";
              String title = "";
              String subtitle = "";

              if (banner is String) {
                imageUrl = banner;
              } else if (banner is Map) {
                imageUrl = banner["imageUrl"] ?? "";
                title = banner["title"] ?? "";
                subtitle = banner["subtitle"] ?? "";
              } else {
                try {
                  imageUrl = banner.image ?? "";
                  title = banner.title ?? "";
                  subtitle = banner.subtitle ?? "";
                } catch (_) {}
              }

              final hasText = title.isNotEmpty || subtitle.isNotEmpty;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12), // ✅ apply to whole stack
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Banner Image
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        cacheWidth: 800,
                        cacheHeight: 400,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade300,
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                          ),
                        ),
                      ),

                      // 🔹 Overlay Gradient
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Appcolor.withOpacity(Appcolor.mehrun, 0.9),
                            ],
                          ),
                        ),
                      ),

                      // 🔹 Text Gradient (optional, if text exists)
                      if (hasText)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // 🔹 Title & Subtitle
                      if (hasText)
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 140,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (title.isNotEmpty)
                                Text(
                                  title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (subtitle.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  subtitle,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),

                      // 🔹 Book Now Button
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: ElevatedButton(
                          onPressed: () {
                            print("Book Now clicked on banner index: $index");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Appcolor.mehrun,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text(
                            "Book Now",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Page Indicator
        if (widget.items.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.items.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 6,
                width: currentPage == index ? 20 : 6,
                decoration: BoxDecoration(
                  color: currentPage == index
                      ? Colors.pink
                      : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// 🔥 Shimmer Loader while waiting for banners
  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          // Fake banner card shimmer
          Container(
            height: widget.height,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          // Fake indicator shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
                  (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 6,
                width: index == 0 ? 20 : 6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
