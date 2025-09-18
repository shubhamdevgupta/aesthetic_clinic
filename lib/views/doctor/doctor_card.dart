import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/Appcolor.dart';

class DoctorCard extends StatefulWidget {
  final String name;
  final String? title;
  final String? imageUrl;
  final int? experience;
  final double? rating;

  const DoctorCard({
    super.key,
    required this.name,
    this.title,
    this.imageUrl,
    this.experience,
    this.rating,
  });

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  bool _isLoading = true;

  /// Extract initials
  String _getInitials(String fullName) {
    final parts = fullName.trim().split(" ");
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts.last[0]).toUpperCase();
  }

  /// Rating Stars
  Widget _buildRatingStars(double rating) {
    final fullStars = rating.floor();
    final halfStar = (rating - fullStars) >= 0.5;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else if (index == fullStars && halfStar) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 16);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 16);
        }
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // 🔑 Responsive sizes
    final cardWidth = screenWidth * 0.4; // ~40% of screen width
    final avatarRadius = screenWidth * 0.1; // avatar scales with screen
    final nameHeight = screenWidth * 0.09; // fixed box for name/title

    final hasValidImage = widget.imageUrl != null &&
        widget.imageUrl!.isNotEmpty &&
        Uri.tryParse(widget.imageUrl!) != null;

    return Container(
      width: cardWidth,
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: _isLoading
          ? _buildShimmerLoader(avatarRadius)
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Appcolor.mehrun.withOpacity(0.1),
            backgroundImage: hasValidImage ? NetworkImage(widget.imageUrl!) : null,
            child: !hasValidImage
                ? Text(
              _getInitials(widget.name),
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Appcolor.mehrun,
              ),
            )
                : null,
          ),
          SizedBox(height: screenWidth * 0.02),

          // 🔒 Fixed-height name section
          SizedBox(
            height: screenWidth * 0.10, // reserve space for 2 lines
            child: Center(
              child: Text(
                '${widget.title ?? ""} ${widget.name}',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.bold,
                  color: Appcolor.mehrun,
                ),
              ),
            ),
          ),

          // ✅ Experience stays aligned across all cards
          if (widget.experience != null) ...[
            const SizedBox(height: 4),
            Text(
              '${widget.experience}+ yrs',
              style: TextStyle(
                fontSize: screenWidth * 0.032,
                color: Appcolor.textColor,
              ),
            ),
          ],

          // ✅ Rating also aligned
          if (widget.rating != null) ...[
            const SizedBox(height: 6),
            _buildRatingStars(widget.rating!),
          ],
        ],
      )
    );
  }

  Widget _buildShimmerLoader(double avatarRadius) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: avatarRadius, backgroundColor: Colors.white),
          const SizedBox(height: 8),
          Container(height: 14, width: 100, color: Colors.white),
          const SizedBox(height: 6),
          Container(height: 12, width: 60, color: Colors.white),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
                  (_) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: 14,
                width: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
