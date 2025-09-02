import 'package:flutter/material.dart';

import 'Appcolor.dart';

class CustomBottomSheet {
  static Future<T?> showCustomBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    double? maxHeight,
    Color? backgroundColor,
    double borderRadius = 24.0,
    double elevation = 8.0,
    EdgeInsets? padding,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CustomBottomSheetContent(
          child: child,
          maxHeight: maxHeight,
          backgroundColor: backgroundColor,
          borderRadius: borderRadius,
          elevation: elevation,
          padding: padding,
        );
      },
    );
  }
}

class CustomBottomSheetContent extends StatelessWidget {
  final Widget child;
  final double? maxHeight;
  final Color? backgroundColor;
  final double borderRadius;
  final double elevation;
  final EdgeInsets? padding;

  const CustomBottomSheetContent({
    Key? key,
    required this.child,
    this.maxHeight,
    this.backgroundColor,
    this.borderRadius = 24.0,
    this.elevation = 8.0,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar with reverse U design
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Main content with reverse U design
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: elevation,
                    offset: const Offset(0, -2),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: elevation * 2,
                    offset: const Offset(0, -4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
                child: Container(
                  padding: padding ?? const EdgeInsets.all(20.0),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Alternative design with more pronounced reverse U shape
class CurvedBottomSheet extends StatelessWidget {
  final Widget child;
  final double? maxHeight;
  final Color? backgroundColor;
  final double elevation;
  final EdgeInsets? padding;

  const CurvedBottomSheet({
    Key? key,
    required this.child,
    this.maxHeight,
    this.backgroundColor,
    this.elevation = 12.0,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Curved handle with reverse U design
          Container(
            margin: const EdgeInsets.only(top: 12.0),
            child: CustomPaint(
              size: const Size(80, 20),
              painter: ReverseUPainter(),
            ),
          ),
          
          // Main content with enhanced elevation
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(top: 4.0),
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28.0),
                  topRight: Radius.circular(28.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: elevation,
                    offset: const Offset(0, -3),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: elevation * 1.5,
                    offset: const Offset(0, -6),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: elevation * 2,
                    offset: const Offset(0, -8),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28.0),
                  topRight: Radius.circular(28.0),
                ),
                child: Container(
                  padding: padding ?? const EdgeInsets.all(24.0),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for reverse U handle
class ReverseUPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    final path = Path();
    
    // Create reverse U shape
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.25, 
      0, 
      size.width * 0.5, 
      0
    );
    path.quadraticBezierTo(
      size.width * 0.75, 
      0, 
      size.width, 
      size.height * 0.5
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Usage example helper
class BottomSheetHelper {
  static Future<T?> showBookingBottomSheet<T>({
    required BuildContext context,
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CurvedBottomSheet(
          backgroundColor: Colors.white,
          elevation: 16.0,
          padding: const EdgeInsets.all(24.0),
          child: child,
        );
      },
    );
  }

  static Future<T?> showServiceBottomSheet<T>({
    required BuildContext context,
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CustomBottomSheetContent(
          backgroundColor:  Appcolor.mehrun,
          borderRadius: 32.0,
          elevation: 20.0,
          padding: const EdgeInsets.all(28.0),
          child: child,
        );
      },
    );
  }
} 