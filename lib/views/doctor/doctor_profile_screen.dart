import 'package:aesthetic_clinic/models/doctor/doctor_detail_response.dart';
import 'package:aesthetic_clinic/providers/home_provider.dart';
import 'package:aesthetic_clinic/views/doctor/doctor_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/ui_state.dart';
import '../../utils/Appcolor.dart';
import '../../utils/ShimerPlaceholder.dart';

class DoctorProfileScreen extends StatefulWidget {
  final String doctorId;

  const DoctorProfileScreen({Key? key, required this.doctorId})
    : super(key: key);

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
          () =>
          Provider.of<HomeProvider>(
            context,
            listen: false,
          ).getDoctorById(widget.doctorId, context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size; // ✅ responsiveness
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Doctor Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          final doctorState = provider.doctorDetailState;

          if (doctorState is Loading || doctorState is Idle) {
            // ✅ Show shimmer instead of loader
            return _buildShimmer(width, height);
          }

          if (doctorState is Error) {
            return const Center(child: Text("Something went wrong"));
          }

          final doctor =
              (doctorState as Success<DoctorDetailModel>).response.data;

          return SingleChildScrollView(
            padding: EdgeInsets.all(width * 0.05), // responsive padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Doctor Header Section
                Container(
                  padding: EdgeInsets.all(width * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Doctor Image
                      SizedBox(
                        width: width * 0.22,
                        height: width * 0.22,
                        child: ClipOval(
                          child:
                          (doctor!.image != null &&
                              doctor.image!.isNotEmpty &&
                              doctor.image!.startsWith('http'))
                              ? Image.network(
                            doctor.image!,
                            fit: BoxFit.cover,
                            cacheWidth: 200,
                            cacheHeight: 200,
                            loadingBuilder:
                                (context, child, loadingProgress) {
                              if (loadingProgress == null)
                                return child;
                              return ShimmerPlaceholder(
                                width: width * 0.18,
                                height: width * 0.18,
                                isCircle: true,
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return _buildInitialsAvatar(doctor.name);
                            },
                          )
                              : _buildInitialsAvatar(doctor.name),
                        ),
                      ),

                      SizedBox(width: width * 0.04),

                      // Doctor Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${doctor.title} ${doctor.name}",
                              style: TextStyle(
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Appcolor.mehrun,
                              ),
                            ),
                            SizedBox(height: height * 0.004),
                            Text(
                              '${doctor.specialization}',
                              style: TextStyle(
                                fontSize: width * 0.038,
                                color: Appcolor.textColor,
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: height * 0.004),
                            Row(
                              children: [
                                Text(
                                  'Experience: ',
                                  style: TextStyle(
                                    fontSize: width * 0.035,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  '${doctor.experience}+ years',
                                  style: TextStyle(
                                    fontSize: width * 0.038,
                                    fontWeight: FontWeight.w600,
                                    color: Appcolor.mehrun,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.02),

                // About Section
                Text(
                  doctor.bio??"",
                  style: TextStyle(
                    fontSize: width * 0.038,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),

                SizedBox(height: height * 0.02),

                _buildSectionTitle(
                  'Specialized In:',
                  doctor.specialization ?? '',
                  width,
                ),

                SizedBox(height: height * 0.02),

                _buildSectionTitle(
                  'Certification:',
                  'Board-certified in Dermatology and Venereology.',
                  width,
                ),

                SizedBox(height: height * 0.02),

                _buildSectionTitle(
                  'Explore My Expertise:',
                  'From diagnosing and treating complex skin conditions to delivering tailored aesthetic procedures, my focus is on achieving results that are both medically sound and visually refined. I specialize in laser therapies for skin rejuvenation, botulinum toxin, fillers, PRP, mesotherapy, and minor dermatologic surgeries.',
                  width,
                ),

                SizedBox(height: height * 0.03),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DoctorReviewScreen(doctorData: doctor),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Appcolor.mehrun),
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.018,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Check Reviews',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13, // ✅ slightly smaller for small screens
                            color: Appcolor.mehrun,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.03),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: check availability
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Appcolor.mehrun,
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.018,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Check Availability',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13, // ✅ reduced size
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ✅ Section Builder
  Widget _buildSectionTitle(String title, String description, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: width * 0.042,
            fontWeight: FontWeight.bold,
            color: Appcolor.mehrun,
          ),
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: width * 0.038,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ✅ Helper widget for initials avatar
  Widget _buildInitialsAvatar(String? name) {
    final initials = (name != null && name
        .trim()
        .isNotEmpty)
        ? name
        .trim()
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase()
        : '?';

    return CircleAvatar(
      backgroundColor: Colors.grey.shade300,
      child: Text(
        initials,
        style: const TextStyle(
          color: Appcolor.mehrun,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ✅ Shimmer UI (for loading)
  Widget _buildShimmer(double width, double height) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(width * 0.05),
      child: Column(
        children: [
          // Doctor header shimmer
          Row(
            children: [
              ShimmerPlaceholder(
                width: width * 0.22,
                height: width * 0.22,
                isCircle: true,
              ),
              SizedBox(width: width * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerPlaceholder(width: width * 0.4, height: 18),
                    SizedBox(height: height * 0.01),
                    ShimmerPlaceholder(width: width * 0.3, height: 14),
                    SizedBox(height: height * 0.01),
                    ShimmerPlaceholder(width: width * 0.5, height: 14),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: height * 0.03),

          // About shimmer
          ShimmerPlaceholder(width: double.infinity, height: 14),
          SizedBox(height: height * 0.01),
          ShimmerPlaceholder(width: double.infinity, height: 14),
          SizedBox(height: height * 0.01),
          ShimmerPlaceholder(width: width * 0.8, height: 14),

          SizedBox(height: height * 0.03),

          // Button shimmer
          Row(
            children: [
              Expanded(
                child: ShimmerPlaceholder(width: double.infinity, height: 40),
              ),
              SizedBox(width: width * 0.03),
              Expanded(
                child: ShimmerPlaceholder(width: double.infinity, height: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
