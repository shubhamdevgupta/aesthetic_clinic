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
    // Trigger main services fetch after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ServiceProvider>(context, listen: false);
      provider.getMainServices(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<ServiceProvider>(
          builder: (context, provider, _) {
            final state = provider.serviceState;

            if (state is Loading) {
              // Instead of CircularProgressIndicator
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      height: 20,
                      width: 160,
                      color: Colors.transparent,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 20,
                          width: 160,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ShimmerWidgets.mainCategories(),
                    const SizedBox(height: 18),
                    ShimmerWidgets.subServicesGrid(),
                  ],
                ),
              );
            }


            if (state is Error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 16),
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
                      .getSubService(_selectedCategoryId!,context);
                });
              }

              return RefreshIndicator(
                onRefresh: ()async{
                  await  provider.getMainServices(context);
                },
                child: SingleChildScrollView(
                  physics:const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Our Main Categories',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Appcolor.mehrun,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildMainCategoriesGrid(services),
                        const SizedBox(height: 24),
                        _buildSubServicesSection(provider),
                        const SizedBox(height: 100),
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

  Widget _buildMainCategoriesGrid(List<Service> categories) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: 120,
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
              width: 90,
              child: _buildCategoryCard(
                service.name,
                service.topServiceImage ?? service.image,
                () {
                  setState(() {
                    _selectedCategoryIndex = index;
                    _selectedCategoryId = service.id;
                  });
                  Provider.of<ServiceProvider>(context, listen: false)
                      .getSubService(service.id,context);
                },
                isSelected: _selectedCategoryIndex == index,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imageUrl, VoidCallback onTap,
      {bool isSelected = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color:
                    isSelected ? Appcolor.mehrun.withOpacity(0.1) : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.image,
                              color: Colors.grey[400],
                              size: 25,
                            ),
                          );
                        },
                      )
                    : Icon(Icons.image, color: Colors.grey[400], size: 25),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black87,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSubServicesSection(ServiceProvider provider) {
    final state = provider.subServiceState;
    if (state is Loading) {
      return ShimmerWidgets.subServicesGrid();
    }
    if (state is Error) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            "",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _selectedCategoryId == null
                ? null
                : () => provider.getSubService(_selectedCategoryId!,context),
            style: ElevatedButton.styleFrom(backgroundColor: Appcolor.mehrun),
            child:
                const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    }
    if (state is Success<ServiceResponse>) {
      final items = state.response.data;
      if (items.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text(
              'No sub services found',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        );
      }
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _SubServiceCard(item: item);
        },
      );
    }
    return const SizedBox.shrink();
  }
}

class _SubServiceCard extends StatelessWidget {
  final ServiceItem item;
  const _SubServiceCard({Key? key, required this.item}) : super(key: key);

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
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceDetailScreen(
                serviceId: item.id,
              ),
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
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Starting From AED ${item.price}',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
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
  // 🔹 Shimmer for main categories (horizontal list)
  static Widget mainCategories() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 90,
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
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 60,
                    height: 10,
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

  // 🔹 Shimmer for sub-services grid
  static Widget subServicesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
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

