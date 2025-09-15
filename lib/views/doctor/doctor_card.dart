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
    final hasValidImage = widget.imageUrl != null &&
        widget.imageUrl!.isNotEmpty &&
        Uri.tryParse(widget.imageUrl!) != null;

    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: _isLoading
          ? _buildShimmerLoader()
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Appcolor.mehrun.withOpacity(0.1),
            backgroundImage: hasValidImage ? NetworkImage(widget.imageUrl!) : null,
            child: !hasValidImage
                ? Text(
              _getInitials(widget.name),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Appcolor.mehrun,
              ),
            )
                : null,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Text(
              '${widget.title ?? ""} ${widget.name}',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Appcolor.mehrun,
              ),
            ),
          ),
          const SizedBox(height: 6),
          if (widget.experience != null)
            Text(
              '${widget.experience}+ yrs',
              style: const TextStyle(
                fontSize: 13,
                color: Appcolor.textColor,
              ),
            ),
          const SizedBox(height: 6),
          if (widget.rating != null) _buildRatingStars(widget.rating!),
        ],
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(radius: 40, backgroundColor: Colors.white),
          const SizedBox(height: 8),
          Container(height: 14, width: 100, color: Colors.white),
          const SizedBox(height: 6),
          Container(height: 12, width: 60, color: Colors.white),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (_) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 14,
              width: 14,
              color: Colors.white,
            )),
          ),
        ],
      ),
    );
  }
}
