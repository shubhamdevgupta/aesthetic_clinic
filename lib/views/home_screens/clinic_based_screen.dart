import 'package:aesthetic_clinic/providers/home_provider.dart';
import 'package:aesthetic_clinic/utils/Appcolor.dart';
import 'package:aesthetic_clinic/views/doctor/doctor_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/banner_list.dart';
import '../../models/doctor/doctor_response.dart';
import '../../services/ui_state.dart';
import '../../utils/CircleShimer.dart';
import '../../utils/ShimerPlaceholder.dart';
import '../../utils/widgets/auto_scroll_banner.dart';
import '../service_screens/service_details.dart';
import '../service_screens/service_popup.dart';

class ClinicBasedScreen extends StatefulWidget {
  const ClinicBasedScreen({super.key});

  @override
  State<ClinicBasedScreen> createState() => _ClinicBasedScreenState();
}

class _ClinicBasedScreenState extends State<ClinicBasedScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = Provider.of<HomeProvider>(context, listen: false);
      await provider.getDashboardData();
      await provider.getDoctorData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final dashboardState = provider.dashboardState;
        final doctorState = provider.doctorState;

        // Loading/Error/NoInternet checks
        if (dashboardState is Loading || doctorState is Loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (dashboardState is Error) {
          return Center(child: Text("dashboardState"));
        }
        if (doctorState is Error) {
          return Center(child: Text(""));
        }
        if (dashboardState is NoInternet || doctorState is NoInternet) {
          return const Center(child: Text("No Internet Connection"));
        }
        if (dashboardState is! Success || doctorState is! Success) {
          return const SizedBox.shrink();
        }

        // ✅ Extract API response safely
        final dashboardResponse =
            (dashboardState as Success<AppConfigurationResponse>).response;
        final doctorResponse =
            (doctorState as Success<DoctorResponse>).response;

        // Handle nested lists safely with null fallback
        final bannerList = dashboardResponse.data
            .expand((item) => item.appConfigs?.banner ?? [])
            .map((banner) => banner.configData?.imageUrl ?? "")
            .toList();

        final topServices = dashboardResponse.data
            .expand((item) => item.topServices ?? [])
            .toList();

        final topChoices = dashboardResponse.data
            .expand((item) => item.recommendedServices ?? [])
            .toList();

        final recommendedProducts = dashboardResponse.data
            .expand((item) => item.recommendedProducts ?? [])
            .toList();

        final personalizeServices = dashboardResponse.data
            .expand((item) => item.personalisedServices ?? [])
            .toList();

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ✅ Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                child: AutoScrollingBanner(items: bannerList, height: 200),
              ),
            ),

            // ✅ Top Services
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 18, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Our Top Services",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Appcolor.mehrun,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: topServices.length,
                        itemBuilder: (context, index) {
                          final service = topServices[index];
                          return ServiceItem(
                            imageUrl: service.topServiceImage!,
                            label: service.name,
                            serviceID: service.id,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Trusted Products
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 18, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Get Our Trusted Products",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Appcolor.mehrun,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: recommendedProducts.length,
                        itemBuilder: (context, index) {
                          final product = recommendedProducts[index];
                          return Container(
                            width: 90,
                            margin: const EdgeInsets.only(right: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.network(
                                  width: 64,
                                  height: 64,
                                  product.featuredImage,
                                  fit: BoxFit.cover,
                                  cacheWidth: 120,
                                  cacheHeight: 120,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return CircleShimmer(size: 64);
                                      },
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.broken_image,
                                        color: Appcolor.mehrun,
                                        size: 24,
                                      ),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      product.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF707070),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Personalized Services
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 18, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Our Personalise Services for You",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Appcolor.mehrun,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: personalizeServices.length,
                        itemBuilder: (context, index) {
                          final personalize = personalizeServices[index];
                          return _topChoiceItem(
                            personalize.id,
                            personalize.name,
                            personalize.description,
                            personalize.image,
                            personalize.price,
                            context,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Top Choices
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 18, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Our Top Choices for You",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Appcolor.mehrun,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: topChoices.length,
                        itemBuilder: (context, index) {
                          final service = topChoices[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ServiceDetailScreen(
                                    serviceId: service.id,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 90,
                              margin: const EdgeInsets.only(right: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: Text(
                                        service.name,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Appcolor.textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    flex: 3,
                                    child: Image.network(
                                      service.image,
                                      fit: BoxFit.cover,
                                      cacheWidth: 120,
                                      cacheHeight: 120,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return CircleShimmer(size: 40);
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.broken_image,
                                                color: Colors.red,
                                                size: 24,
                                              ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Doctors
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 18, 8, 12),
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
                      height: 190,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: doctorResponse.data.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final doctor = doctorResponse.data[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DoctorProfileScreen(doctorId: doctor.id),
                                ),
                              );
                            },
                            child: Container(
                              width: 140,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 84,
                                    height: 84,
                                    child: ClipOval(
                                      child: Image.network(
                                        '${doctor.image}',
                                        fit: BoxFit.cover,
                                        cacheWidth: 120,
                                        cacheHeight: 120,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return const ShimmerPlaceholder(
                                                width: 84,
                                                height: 84,
                                                isCircle: true,
                                              );
                                            },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
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
                                  const SizedBox(height: 6),
                                  Text(
                                    '${doctor.title} ${doctor.name}',
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Appcolor.mehrun,
                                    ),
                                  ),
                                  if (doctor.experience != null) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      '${doctor.experience}+ yrs',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Appcolor.textColor,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _topChoiceItem(
    String serviceId,
    String title,
    String description,
    String imageUrl,
    String price,
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => ServicePopup(
            id: serviceId,
            title: title,
            description: description,
            price: "2",
            duration: "30 Mins",
            imageUrl: imageUrl,
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                height: 160,
                width: 160,
                fit: BoxFit.cover,
                cacheWidth: 640,
                cacheHeight: 640,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const ShimmerPlaceholder(
                    width: 160,
                    height: 160,
                    borderRadius: 16,
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 160,
                  width: 160,
                  color: const Color(0xFFFFEBEE),
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, color: Colors.red),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/icons/ic_rectangle.png',
                  height: 64,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Starting From $price",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceItem extends StatelessWidget {
  final String imageUrl;
  final String label;
  final String serviceID;

  const ServiceItem({
    super.key,
    required this.imageUrl,
    required this.label,
    required this.serviceID,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailScreen(serviceId: serviceID),
          ),
        );
      },
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Appcolor.textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: ClipOval(
                child: Image.network(
                  imageUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  cacheWidth: 120,
                  cacheHeight: 120,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return CircleShimmer(size: 40);
                  },
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
