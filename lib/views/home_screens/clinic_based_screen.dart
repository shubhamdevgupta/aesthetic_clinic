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
      await provider.getDashboardData(context);
      await provider.getDoctorData(context);
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
            .expand((item) => item.appConfigs.banner ?? [])
            .map(
              (banner) => {
                "imageUrl": banner.configData?.imageUrl ?? "",
                "title": banner.configData?.title ?? "",
                "subtitle": banner.configData?.subtitle ?? "",
              },
            )
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

        return RefreshIndicator(
          onRefresh: () async {
            await provider.getDashboardData(context);
            await provider.getDoctorData(context);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ✅ Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                  child: AutoScrollingBanner(items: bannerList, height: 200),
                ),
              ),

              // ✅ Top Services
              // Replace your SliverToBoxAdapter with this
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
                        height: 140, // enough room for text + image
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
                        height: 160, // increased height to fit image + text
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: recommendedProducts.length,
                          itemBuilder: (context, index) {
                            final product = recommendedProducts[index];
                            return Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        product.featuredImage,
                                        fit: BoxFit.contain,
                                        // show full product
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.broken_image,
                                                  color: Appcolor.mehrun,
                                                  size: 40,
                                                ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Expanded(
                                    flex: 3,
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
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                        height: 180,
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
                              personalize.personalisedServiceImages,
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
                        height: 180,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: personalizeServices.length,
                          itemBuilder: (context, index) {
                            final service = personalizeServices[index];
                            return Container(
                              width: 160, // 👈 FIX: set width
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  fit: StackFit.expand, // 👈 make stack fill
                                  children: [
                                    service.image.isNotEmpty
                                        ? Image.network(
                                            service.image,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                                      color: Colors.grey[300],
                                                    ),
                                          )
                                        : Container(color: Colors.grey[300]),

                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Appcolor.withOpacity(
                                              Appcolor.mehrun,
                                              0.8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      left: 12,
                                      right: 12,
                                      bottom: 12,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            service.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Starting From AED ${service.price}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
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
                                    builder: (context) => DoctorProfileScreen(
                                      doctorId: doctor.id,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 140,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
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
                                              (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
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
                                                    backgroundColor:
                                                        Colors.grey,
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
          ),
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
            price: price,
            duration: "30 Mins",
            imageUrl: imageUrl,
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background image
              Image.network(
                imageUrl,
                width: double.infinity,
                height: 200,
                // fixed height for consistency
                fit: BoxFit.cover,
                // ✅ ensures image fills area nicely
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const ShimmerPlaceholder(
                    width: 160,
                    height: 200,
                    borderRadius: 16,
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: const Color(0xFFFFEBEE),
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, color: Colors.red),
                ),
              ),

              // Positioned text
              Positioned(
                left: 8,
                right: 8,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Appcolor.mehrun,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "Starting From $price",
                        style: TextStyle(
                          color: Appcolor.textColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceItem extends StatefulWidget {
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
  State<ServiceItem> createState() => _ServiceItemState();
}

class _ServiceItemState extends State<ServiceItem> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  void _navigateToDetails() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) =>
            ServiceDetailScreen(serviceId: widget.serviceID),
        transitionsBuilder: (_, animation, __, child) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.ease,
          ));
          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Hero(
        tag: "service ${widget.serviceID}",
        child: Material(
          color: Colors.transparent, // needed for ripple
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _navigateToDetails,
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            splashColor: Appcolor.mehrun.withOpacity(0.1), // custom ripple
            highlightColor: Colors.transparent,
            child: Container(
              width: 90,
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        widget.label,
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
                  const SizedBox(height: 6),
                  Expanded(
                    flex: 7,
                    child: ClipOval(
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return CircleShimmer(size: 48);
                        },
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image,
                            color: Colors.red, size: 32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
