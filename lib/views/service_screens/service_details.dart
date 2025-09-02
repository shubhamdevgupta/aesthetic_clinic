import 'package:aesthetic_clinic/utils/widgets/auto_scroll_banner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      serviceProvider.getServiceBYId(widget.serviceId);
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
            child: CartIconButton(itemCount: 5, onPressed: () {}),
          ),
        ],
      ),
      body: Consumer<ServiceProvider>(
        builder: (context, serviceProvider, child) {
          // Show loading indicator while fetching data
          if (serviceProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Show error message if service detail is null
          if (serviceProvider.serviceDetailResponse == null) {
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
                      serviceProvider.getServiceBYId(widget.serviceId);
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

          // Get service data from API response
          final serviceData = serviceProvider.serviceDetailResponse!.data;

          // Prepare images list based on available images from API
          final List<String> serviceImages = [];
          serviceImages.add(serviceData.image);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoScrollingBanner(
                  items: [serviceData.image],
                  bannerBuilder: (context, item, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(item, fit: BoxFit.cover),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Main Service Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ServiceCard(
                    name: serviceData.name,
                    price: serviceData.price,
                    description:
                        serviceData?.description ?? 'No description available',
                    isOnSale: serviceData?.isRecommended ?? false,
                    isTopService: serviceData?.isTopService ?? false,
                    onBook: () {
                      // Handle booking with actual service data
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Booking ${serviceData?.name ?? 'service'}...',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  ),
                ),

                // Available Doctors Section (if doctors exist)
                if (serviceData.doctors?.isNotEmpty == true) ...[
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
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 160, // set height to fit horizontal items
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: serviceData!.doctors!.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final doctor = serviceData.doctors![index];
                              return Container(
                                width: 140, // fixed width for each horizontal card
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.red.shade100,
                                      child: Icon(
                                        Icons.person,
                                        color: Appcolor.mehrun,
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${doctor.title ?? 'Dr.'} ${doctor.name ?? 'Doctor'}',
                                      textAlign: TextAlign.center,
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
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

// webzila
                /*// About Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceData?.name ?? 'Our Services',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        serviceData?.description ??
                            'We provide high-quality medical and aesthetic services with expert care and advanced technology.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),

                      // Extra details if available
                      if (serviceData?.extraDetail != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Additional Information',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          serviceData!.extraDetail!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                      ],

                      // Service highlights
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (serviceData?.isTopService == true)
                            _buildServiceBadge('Top Service', Colors.blue),
                          if (serviceData?.isRecommended == true)
                            _buildServiceBadge('Recommended', Colors.green),
                          if (serviceData?.personalisedService == true)
                            _buildServiceBadge('Personalized', Colors.purple),
                        ],
                      ),
                    ],
                  ),
                ),*/
                SizedBox(height: 18,),

                // Static Treatment Guide Section (since not in API)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Why Choose Our Services?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'We combine advanced medical technology with personalized care to deliver exceptional results. Our experienced team ensures safe, effective treatments tailored to your unique needs.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 14,),
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
                          color: Colors.red,
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
                          color: Colors.black87,
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
        },
      ),
    );
  }
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
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Appcolor.mehrun,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: onBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appcolor.mehrun,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Book a Slot',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

Widget _buildServiceBadge(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
    ),
  );
}
