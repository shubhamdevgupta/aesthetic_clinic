import 'package:aesthetic_clinic/models/doctor/doctor_detail_response.dart';
import 'package:aesthetic_clinic/models/doctor/get_review.dart';
import 'package:aesthetic_clinic/models/doctor/submit_doctor_review.dart';
import 'package:aesthetic_clinic/utils/Appcolor.dart';
import 'package:aesthetic_clinic/utils/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // ⭐ Added shimmer package

import '../../providers/home_provider.dart';
import '../../services/ui_state.dart';

class DoctorReviewScreen extends StatefulWidget {
  final DoctorData? doctorData;
  final String? doctorId;

  const DoctorReviewScreen({Key? key, this.doctorData, this.doctorId})
    : super(key: key);

  @override
  State<DoctorReviewScreen> createState() => _DoctorReviewScreenState();
}

class _DoctorReviewScreenState extends State<DoctorReviewScreen> {
  TextEditingController reviewController = TextEditingController();

  String? _doctorId;
  DoctorData? _doctorData;

  @override
  void initState() {
    super.initState();

    _doctorData = widget.doctorData;
    _doctorId = widget.doctorData?.id ?? widget.doctorId;

    if (_doctorId != null && _doctorId!.isNotEmpty) {
      final provider = Provider.of<HomeProvider>(context, listen: false);

      // ✅ Always fetch reviews
      provider.getDoctorReview(_doctorId!, context);

      // ✅ If doctorData is null, trigger doctor details API
      if (_doctorData == null) {
        provider.getDoctorById(_doctorId!, context);
      }
    }
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Doctor Review"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          final doctorDetailState = provider.doctorDetailState;
          final doctorReviewState = provider.doctorReviewState;
          final submitReviewState = provider.submitReviewState;

          // ✅ Bind _doctorData from doctorDetailState (reactive)
          if (_doctorData == null && doctorDetailState is Success<DoctorDetailModel>) {
            _doctorData = doctorDetailState.response.data;
          }

          if (doctorReviewState is Loading ||
              doctorDetailState is Loading ||
              submitReviewState is Loading) {
            return shimmerLoader();
          }

          if (doctorReviewState is Success<DoctorReview>) {
            final doctorReviews = doctorReviewState.response.data;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Always show doctor card (either from widget or API)
                  if (_doctorData != null) buildDoctorCard(_doctorData!),

                  const SizedBox(height: 20),

                  // ✅ Overall Rating
                  Row(
                    children: [
                      buildStarRating(
                        doctorReviews.isNotEmpty
                            ? double.tryParse(doctorReviews.first.rating) ?? 0.0
                            : 0.0,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        doctorReviews.isNotEmpty
                            ? "${doctorReviews.first.rating} Ratings"
                            : "No Ratings Yet",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ✅ User Rating Input
                  buildStarRating(
                    provider.selectedRating,
                    isInteractive: true,
                    size: 28,
                    onChanged: (val) => provider.setSelectedRating(val),
                  ),

                  const SizedBox(height: 16),

                  // ⭐ Review Input
                  TextField(
                    controller: reviewController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Write your review...",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ✅ Submit Review Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (reviewController.text.isEmpty) {
                          ToastHelper.showToastMessage(
                            "Please enter your Review",
                          );
                        } else if (_doctorId != null) {
                          await provider.submitReview(
                            provider.selectedRating.toString(),
                            reviewController.text,
                            _doctorId!,
                            context,
                          );

                          if (provider.submitReviewState
                          is Success<ReviewResponse>) {
                            final response =
                                (provider.submitReviewState as Success<ReviewResponse>)
                                    .response;
                            ToastHelper.showToastMessage(response.message);
                            provider.setSelectedRating(0);
                            reviewController.clear();

                            // ✅ Refresh reviews after submit
                            provider.getDoctorReview(_doctorId!, context);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolor.mehrun,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Submit Review',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ✅ Reviews List
                  doctorReviews.isEmpty
                      ? const Center(child: Text("No reviews yet"))
                      : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: doctorReviews.length,
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final review = doctorReviews[index];
                      return ReviewCard(
                        name:
                        "${review.reviewer.firstName} ${review.reviewer.lastName}",
                        date: review.date,
                        rating: review.rating,
                        comment: review.review,
                        avatarColor: Appcolor.mehrun,
                      );
                    },
                  ),
                ],
              ),
            );
          }

          return shimmerLoader();
        },
      ),
    );
  }

  // ✅ Extracted reusable doctor card widget
  Widget buildDoctorCard(DoctorData doctor) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Appcolor.mehrun,
            backgroundImage: (doctor.image != null && doctor.image!.isNotEmpty)
                ? NetworkImage(doctor.image!)
                : null,
            child: (doctor.image == null || doctor.image!.isEmpty)
                ? Text(
              doctor.name
                  ?.split(" ")
                  .map((n) => n[0])
                  .join("")
                  .toUpperCase() ??
                  "",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name ?? "",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Appcolor.mehrun,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.specialization ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${doctor.experience ?? ""} + years",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ⭐ Reusable star builder
Widget buildStarRating(
  double rating, {
  bool isInteractive = false,
  double size = 20,
  Function(double)? onChanged,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(5, (index) {
      double starValue = index + 1.0;

      IconData icon;
      if (rating >= starValue) {
        icon = Icons.star;
      } else if (rating >= starValue - 0.5) {
        icon = Icons.star_half;
      } else {
        icon = Icons.star_border;
      }

      return GestureDetector(
        onTap: isInteractive ? () => onChanged?.call(starValue) : null,
        child: Icon(icon, color: Appcolor.mehrun, size: size),
      );
    }),
  );
}

/// ⭐ Shimmer loader widget
Widget shimmerLoader() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
  );
}

class ReviewCard extends StatelessWidget {
  final String name;
  final String date;
  final String rating;
  final String comment;
  final Color avatarColor;

  const ReviewCard({
    Key? key,
    required this.name,
    required this.date,
    required this.rating,
    required this.comment,
    required this.avatarColor,
  }) : super(key: key);

  Widget buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        double starValue = index + 1.0;

        IconData icon;
        if (rating >= starValue) {
          icon = Icons.star;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }

        return Icon(icon, color: Appcolor.mehrun, size: 16);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: avatarColor,
              child: Text(
                name.split(' ').map((n) => n[0]).join('').toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            buildStarRating(double.tryParse(rating) ?? 0.0),
          ],
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 52),
          child: Text(
            comment,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
