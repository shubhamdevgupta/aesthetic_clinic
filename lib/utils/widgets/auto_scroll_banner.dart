import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AutoScrollingBanner<T> extends StatefulWidget {
  final List<T> items; // dynamic list of items
  final double height;
  final Duration autoScrollDelay;
  final Widget Function(BuildContext context, T item, int index) bannerBuilder;
  final List<Widget> Function(BuildContext context, T item, int index)?
  stackChildrenBuilder; // optional stack children
  final Widget? onEmpty;

  const AutoScrollingBanner({
    super.key,
    required this.items,
    required this.bannerBuilder,
    this.stackChildrenBuilder,
    this.height = 180,
    this.autoScrollDelay = const Duration(seconds: 3),
    this.onEmpty,
  });

  @override
  State<AutoScrollingBanner<T>> createState() =>
      _AutoScrollingBannerState<T>();
}

class _AutoScrollingBannerState<T> extends State<AutoScrollingBanner<T>> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (widget.items.isNotEmpty) {
      Future.delayed(widget.autoScrollDelay, autoScroll);
    }
  }

  void autoScroll() {
    if (!mounted || widget.items.isEmpty) return;

    currentPage = (currentPage + 1) % widget.items.length;

    _pageController.animateToPage(
      currentPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

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

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final base = widget.bannerBuilder(context, widget.items[index], index);

              // Wrap with Stack if optional children exist
              if (widget.stackChildrenBuilder != null) {
                final children =
                widget.stackChildrenBuilder!(context, widget.items[index], index);

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    base,
                    ...children,
                  ],
                );
              }

              return base;
            },
          ),
        ),
        const SizedBox(height: 8),
        SmoothPageIndicator(
          controller: _pageController,
          count: widget.items.length,
          effect: const WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            spacing: 6,
            activeDotColor: Colors.pink,
            dotColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}
