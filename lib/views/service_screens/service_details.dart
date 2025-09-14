import 'package:aesthetic_clinic/models/service/service_detail_response.dart';
import 'package:aesthetic_clinic/services/ui_state.dart';
import 'package:aesthetic_clinic/utils/widgets/auto_scroll_banner.dart';
import 'package:aesthetic_clinic/views/booking_screens/booking_slot_screen.dart';
import 'package:aesthetic_clinic/views/doctor/doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../providers/service_provider.dart';
import '../../utils/Appcolor.dart';
import '../../utils/widgets/CartIconButton.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceId;

  const ServiceDetailScreen({Key? key, required this.serviceId})
    : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Call the API to get service details by ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final serviceProvider = Provider.of<ServiceProvider>(
        context,
        listen: false,
      );
      serviceProvider.getServiceDetial(widget.serviceId, context);
    });
  }

  final List<String> treatmentCategories = [
    'Wrinkle\nReduction',
    'Facial\nContouring',
    'Skin\nHydration',
    'Specialized\nInjectables',
  ];

  final List<Map<String, dynamic>> otherServices = [
    {
      'name': 'Laser Hair\nRemoval',
      'icon': Icons.spa_outlined,
      'color': Colors.orange.shade100,
    },
    {
      'name': 'Dermatology and\nAesthetics',
      'icon': Icons.face_outlined,
      'color': Colors.pink.shade100,
    },
    {
      'name': 'Dental\nServices',
      'icon': Icons.medical_services_outlined,
      'color': Colors.blue.shade100,
    },
    {
      'name': 'Hijama\nTherapy',
      'icon': Icons.healing_outlined,
      'color': Colors.purple.shade100,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Service Detail"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: EdgeInsetsGeometry.only(right: 15),
            child: CartIconButton(itemCount: 0, onPressed: () {}),
          ),
        ],
      ),
      body: Consumer<ServiceProvider>(
        builder: (context, serviceProvider, child) {
          final serviceDetialState = serviceProvider.serviceDetialState;

          if (serviceDetialState is Loading) {
            return _buildShimmerLoader(screenWidth);
          }

          // Show error message if service detail is null
          if (serviceDetialState is Error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unable to load service details',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      serviceProvider.getServiceDetial(
                        widget.serviceId,
                        context,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          if (serviceDetialState is Success<ServiceDetailResponse>) {
            final serviceData = (serviceDetialState).response.data;
            // Prepare images list based on available images from API
            final List<String> serviceImages = [];
            serviceImages.add(serviceData.image);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.all(8),
                    child: // In your ClinicBasedScreen build method, replace the current banner section with:
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                      child: AutoScrollingBanner(items: [serviceData.image]),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Main Service Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ServiceCard(
                      name: serviceData.name,
                      price: serviceData.price,
                      description:
                          serviceData?.description ??
                          'No description available',
                      isOnSale: serviceData?.isRecommended ?? false,
                      isTopService: serviceData?.isTopService ?? false,
                      onBook: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookingSlotScreen(serviceId: serviceData.id),
                          ),
                        );
                      },
                    ),
                  ),

                  // Available Doctors Section (if doctors exist)
                  if (serviceData.doctors.isNotEmpty == true) ...[
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Choose Your Professional',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Appcolor.mehrun,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 190, // set height to fit horizontal items
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: serviceData.doctors.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final doctor = serviceData.doctors[index];
                                return DoctorCard(
                                  name: doctor.name,
                                  experience: doctor.experience,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 18),

                  // Static Treatment Guide Section (since not in API)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Why Choose Our Services?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Appcolor.mehrun,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'We combine advanced medical technology with personalized care to deliver exceptional results. Our experienced team ensures safe, effective treatments tailored to your unique needs.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Appcolor.textColor,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 14),
                  // Static Treatment Categories (since not in API response)
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: treatmentCategories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        return Container(
                          width: 120,
                          decoration: BoxDecoration(
                            color: Appcolor.mehrun,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              treatmentCategories[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Other Services Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Our Other Top Services',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Appcolor.mehrun,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.5,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: otherServices.length,
                          itemBuilder: (context, index) {
                            final service = otherServices[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: service['color'],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    service['icon'],
                                    size: 32,
                                    color: Colors.grey.shade700,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    service['name'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

Widget _shimmerBox({double? height, double? width, double radius = 6}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}
Widget _buildShimmerLoader(double screenWidth) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: screenWidth * 0.5,
              width: double.infinity,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Service card shimmer
          _shimmerBox(height: 120, width: double.infinity),
          const SizedBox(height: 20),

          // Why choose section shimmer
          _shimmerBox(height: 20, width: 180),
          const SizedBox(height: 12),
          _shimmerBox(height: 14, width: double.infinity),
          const SizedBox(height: 8),
          _shimmerBox(height: 14, width: screenWidth * 0.7),

          const SizedBox(height: 20),

          // Treatment categories shimmer
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return _shimmerBox(height: 60, width: 100, radius: 8);
              },
            ),
          ),

          const SizedBox(height: 20),

          // Other services shimmer
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 4,
            itemBuilder: (_, __) {
              return _shimmerBox(height: 80, width: double.infinity, radius: 12);
            },
          ),
        ],
      ),
    ),
  );
}

class ServiceCard extends StatelessWidget {
  final String name;
  final String price;
  final String description;
  final bool isOnSale;
  final bool isTopService;
  final VoidCallback onBook;

  const ServiceCard({
    Key? key,
    required this.name,
    required this.price,
    required this.description,
    required this.isOnSale,
    this.isTopService = false,
    required this.onBook,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // 👇 Add padding inside container
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isOnSale || isTopService)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isTopService ? Colors.blue : Colors.orange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isTopService ? 'Top Service' : 'Recommended',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const Spacer(),
              Text(
                "AED $price",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Appcolor.mehrun,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolor.mehrun,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Book Slot',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
