import 'package:aesthetic_clinic/views/service_screens/service_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/service/all_services.dart';
import '../../models/service/sub_service.dart';
import '../../providers/service_provider.dart';
import '../../services/ui_state.dart';
import '../../utils/Appcolor.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServiceScreen> {
  int _selectedCategoryIndex = 0;
  String? _selectedCategoryId;
  bool _requestedInitialSub = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ServiceProvider>(context, listen: false);
      provider.getMainServices(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<ServiceProvider>(
          builder: (context, provider, _) {
            final state = provider.serviceState;

            if (state is Loading) {
              return Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.02),
                    Container(
                      height: height * 0.025,
                      width: width * 0.4,
                      color: Colors.transparent,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: height * 0.025,
                          width: width * 0.4,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    ShimmerWidgets.mainCategories(height, width),
                    SizedBox(height: height * 0.025),
                    ShimmerWidgets.subServicesGrid(height, width),
                  ],
                ),
              );
            }

            if (state is Error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: height * 0.08, color: Colors.grey.shade400),
                    SizedBox(height: height * 0.015),
                    Text(
                      "Something went wrong",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: width * 0.04,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    ElevatedButton(
                      onPressed: () => provider.getMainServices(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolor.mehrun,
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

            if (state is Success<GetAllService>) {
              final services = state.response.data;
              if (!_requestedInitialSub && services.isNotEmpty) {
                _requestedInitialSub = true;
                _selectedCategoryIndex = 0;
                _selectedCategoryId = services.first.id;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Provider.of<ServiceProvider>(context, listen: false)
                      .getSubService(_selectedCategoryId!, context);
                });
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await provider.getMainServices(context, forceRefresh: true);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.025),
                        Text(
                          'Our Main Categories',
                          style: TextStyle(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Appcolor.mehrun,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        _buildMainCategoriesGrid(
                            services, width, height),
                        SizedBox(height: height * 0.03),
                        _buildSubServicesSection(provider, width, height),
                        SizedBox(height: height * 0.1),
                      ],
                    ),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildMainCategoriesGrid(List<Service> categories, double width, double height) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: 120, // ✅ fixed height looks consistent on all screens
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final service = categories[index];
            return Container(
              margin: EdgeInsets.only(
                left: 8,
                right: index < categories.length - 1 ? 8 : 8,
              ),
              child: _buildCategoryCard(
                service.name,
                service.topServiceImage ?? service.image,
                    () {
                  setState(() {
                    _selectedCategoryIndex = index;
                    _selectedCategoryId = service.id;
                  });
                  Provider.of<ServiceProvider>(context, listen: false)
                      .getSubService(service.id, context);
                },
                isSelected: _selectedCategoryIndex == index,
                width: width,
              ),
            );
          },
        ),
      )
    );
  }

  Widget _buildCategoryCard(String title, String imageUrl, VoidCallback onTap,
      {bool isSelected = false, required double width}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width * 0.3,
        decoration: BoxDecoration(
          color: isSelected ? Appcolor.mehrun.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isSelected ? Appcolor.mehrun : Colors.transparent,
            width: isSelected ? 1 : 0,
          ),
        ),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: 4),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width * 0.03,
                color: Appcolor.textColor,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              fit: BoxFit.contain, // 👈 better than cover
              height: width * 0.18,
              width: width * 0.18,
            )
                : Icon(Icons.image, color: Colors.grey[400], size: width * 0.08),
          ),
        ],
      ),

    ),
    );
  }

  Widget _buildSubServicesSection(
      ServiceProvider provider, double width, double height) {
    final state = provider.subServiceState;
    if (state is Loading) {
      return ShimmerWidgets.subServicesGrid(height, width);
    }
    if (state is Error) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height * 0.015),
          Icon(Icons.error_outline, size: height * 0.06, color: Colors.grey.shade400),
          SizedBox(height: height * 0.01),
          Text(
            "Failed to load sub services",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: width * 0.035),
          ),
          SizedBox(height: height * 0.015),
          ElevatedButton(
            onPressed: _selectedCategoryId == null
                ? null
                : () => provider.getSubService(_selectedCategoryId!, context),
            style: ElevatedButton.styleFrom(backgroundColor: Appcolor.mehrun),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    }
    if (state is Success<ServiceResponse>) {
      final items = state.response.data;
      if (items.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.04),
            child: Text(
              'No sub services found',
              style: TextStyle(
                fontSize: width * 0.035,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        );
      }
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: width / (height * 0.6),
          crossAxisSpacing: width * 0.03,
          mainAxisSpacing: width * 0.03,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _SubServiceCard(item: item, width: width);
        },
      );
    }
    return const SizedBox.shrink();
  }
}

class _SubServiceCard extends StatelessWidget {
  final ServiceItem item;
  final double width;
  const _SubServiceCard({Key? key, required this.item, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceDetailScreen(serviceId: item.id),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Positioned.fill(
                child: item.image.isNotEmpty
                    ? Image.network(
                  item.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey[300]),
                )
                    : Container(color: Colors.grey[300]),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Appcolor.withOpacity(Appcolor.mehrun, 0.8),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: width * 0.03,
                right: width * 0.03,
                bottom: width * 0.03,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: width * 0.01),
                    Text(
                      'Starting From AED ${item.price}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.03,
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

class ShimmerWidgets {
  static Widget mainCategories(double height, double width) {
    return SizedBox(
      height: height * 0.15,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: width * 0.02),
            width: width * 0.22,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: width * 0.12,
                    height: width * 0.12,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Container(
                    width: width * 0.15,
                    height: height * 0.012,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget subServicesGrid(double height, double width) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: width / (height * 0.6),
        crossAxisSpacing: width * 0.03,
        mainAxisSpacing: width * 0.03,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}
