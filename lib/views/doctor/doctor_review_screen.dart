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
  final DoctorData doctorData;

  DoctorReviewScreen({Key? key, required this.doctorData}) : super(key: key);

  @override
  State<DoctorReviewScreen> createState() => _DoctorReviewScreenState();
}

class _DoctorReviewScreenState extends State<DoctorReviewScreen> {
  TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => Provider.of<HomeProvider>(
        context,
        listen: false,
      ).getDoctorReview(widget.doctorData.id ?? "", context),
    );
  }
  @override
  void dispose() {
    super.dispose();
    reviewController.clear();
  }


  /// ⭐ Reusable star builder (supports half stars)
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
          icon = Icons.star; // full star
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half; // half star
        } else {
          icon = Icons.star_border; // empty star
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
          final doctoReviewState = provider.doctorReviewState;
          final submitReviewState = provider.submitReviewState;

          // 🔹 Show shimmer for Idle & Loading
          if (doctoReviewState is Idle ||
              doctoReviewState is Loading ||
              submitReviewState is Loading) {
            return shimmerLoader();
          }

          // 🔹 Success: safe cast now
          if (doctoReviewState is Success<DoctorReview>) {
            final doctor = doctoReviewState.response.data;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Doctor Header
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // ⭐ Doctor image with fallback initials
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Appcolor.mehrun,
                          backgroundImage: (widget.doctorData.image != null &&
                              widget.doctorData.image!.isNotEmpty)
                              ? NetworkImage(widget.doctorData.image!)
                              : null,
                          child: (widget.doctorData.image == null ||
                              widget.doctorData.image!.isEmpty)
                              ? Text(
                            widget.doctorData.name
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
                                '${widget.doctorData.name}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Appcolor.mehrun,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.doctorData.specialization}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${widget.doctorData.experience} + years',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ✅ Overall Rating
                  Row(
                    children: [
                      buildStarRating(
                        doctor.isNotEmpty
                            ? double.tryParse(doctor.first.rating) ?? 0.0
                            : 0.0,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        doctor.isNotEmpty
                            ? "${doctor.first.rating} Ratings"
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

                  // ⭐ Stylish TextField
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
                        if(reviewController.text.isEmpty){
                          ToastHelper.showToastMessage("Please enter your Review");

                        }else{
                        await provider.submitReview(
                          provider.selectedRating.toString(),
                          reviewController.text,
                          widget.doctorData.id ?? "",
                          context,
                        );

                        if (provider.submitReviewState is Success<ReviewResponse>) {
                          final response =
                              (provider.submitReviewState as Success<ReviewResponse>)
                                  .response;
                          ToastHelper.showToastMessage(response.message);
                          provider.setSelectedRating(0);
                          reviewController.clear();
                          provider.getDoctorReview(widget.doctorData.id??"", context);
                        }}
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
                  doctor.isEmpty
                      ? const Center(child: Text("No reviews yet"))
                      : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: doctor.length,
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final review = doctor[index];
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

          return shimmerLoader(); // fallback
        },
      ),
    );
  }
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
