import 'package:flutter/material.dart';
import 'appcolor.dart';

/// A reusable shimmer placeholder utility.
/// Can be circular or rectangular depending on [isCircle].
class ShimmerPlaceholder extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final bool isCircle;
  final bool isProgress; // if true, shows circular loader instead of shimmer

  const ShimmerPlaceholder({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
    this.isCircle = false,
    this.isProgress = false,
  }) : super(key: key);

  @override
  State<ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<ShimmerPlaceholder>
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
    // If user wants a circular progress indicator instead of shimmer
    if (widget.isProgress) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: Appcolor.mehrun,
        ),
      );
    }

    // Shimmer effect
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius:
            widget.isCircle ? null : BorderRadius.circular(widget.borderRadius),
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
