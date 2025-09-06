import 'package:aesthetic_clinic/models/doctor/doctor_detail_response.dart';
import 'package:aesthetic_clinic/providers/home_provider.dart';
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
          () => Provider.of<HomeProvider>(context, listen: false).getDoctorById(widget.doctorId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Doctor Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          final doctorState = provider.doctorState;
          if ( doctorState is Loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (doctorState is Error) {
            return Center(child: Text(""));
          }
          final doctor = (doctorState as Success<DoctorDetailModel>).response.data;

        //  final doctor = provider.doctorDetailResponse!.data;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor Header Section
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Doctor Image
                      SizedBox(
                        width: 84,
                        height: 84,
                        child: ClipOval(
                          child: Image.network(
                            '${doctor!.image}',
                            fit: BoxFit.cover,
                            cacheWidth: 120,
                            cacheHeight: 120,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const ShimmerPlaceholder(
                                width: 64,
                                height: 64,
                                isCircle: true,
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                            const CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.broken_image,
                                color: Appcolor.mehrun,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),
                      // Doctor Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${doctor.title} ${doctor.name}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Appcolor.mehrun,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${doctor.specialization}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Appcolor.textColor,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Experience: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  '${doctor.experience}+ years',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Appcolor.mehrun,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // About Section
                Text(
                  '${doctor.bio}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                // Specialized In Section
                const Text(
                  'Specialized In:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Appcolor.mehrun,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${doctor.specialization}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                // Certification Section
                const Text(
                  'Certification:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Appcolor.mehrun,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Board-certified in Dermatology and Venereology.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                // Explore My Expertise Section
                const Text(
                  'Explore My Expertise:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Appcolor.mehrun,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'From diagnosing and treating complex skin conditions to delivering tailored aesthetic procedures, my focus is on achieving results that are both medically sound and visually refined. I specialize in laser therapies for skin rejuvenation, botulinum toxin, fillers, PRP, mesotherapy, and minor dermatologic surgeries.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Handle check reviews
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Appcolor.mehrun),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Check Reviews',
                            style: TextStyle(
                              color: Appcolor.mehrun,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle check availability
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Appcolor.mehrun,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Check Availability',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
