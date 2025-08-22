
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/service_provider.dart';
import '../../utils/widgets/CartIconButton.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceId;

  const ServiceDetailScreen({
    Key? key,
    required this.serviceId,
  }) : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Call the API to get service details by ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
              padding: EdgeInsetsGeometry.only(right: 15),
              child: CartIconButton(itemCount: 5, onPressed: (){})),
        ],
      ),
      body: Consumer<ServiceProvider>(
        builder: (context, serviceProvider, child) {
          // Show loading indicator while fetching data
          if (serviceProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
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
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      serviceProvider.getServiceBYId(widget.serviceId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
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
          if (serviceData?.image != null) {
            serviceImages.add(serviceData!.image!);
          }
          if (serviceData?.topServiceImage != null) {
            serviceImages.add(serviceData!.topServiceImage!);
          }
          if (serviceData?.personalisedServiceImages != null) {
            serviceImages.add(serviceData!.personalisedServiceImages!);
          }

          // If no images from API, use fallback
          if (serviceImages.isEmpty) {
            serviceImages.add('https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80');
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Carousel Section
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: serviceImages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(serviceImages[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Page Indicator
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    serviceImages.length,
                        (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == _currentPage ? Colors.red : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Main Service Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ServiceCard(
                    name: serviceData?.name ?? 'Service Name',
                    price: serviceData?.price != null && serviceData!.price != "0.00"
                        ? 'AED ${serviceData.price}'
                        : 'Contact for Price',
                    description: serviceData?.description ?? 'No description available',
                    bookings: 'Popular service - Book now',
                    isOnSale: serviceData?.isRecommended ?? false,
                    isTopService: serviceData?.isTopService ?? false,
                    onBook: () {
                      // Handle booking with actual service data
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Booking ${serviceData?.name ?? 'service'}...'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  ),
                ),

                // Available Doctors Section (if doctors exist)
                if (serviceData.doctors?.isNotEmpty == true) ...[
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Available Doctors',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: serviceData!.doctors!.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final doctor = serviceData.doctors![index];
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.red.shade100,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${doctor.title ?? 'Dr.'} ${doctor.name ?? 'Doctor'}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          doctor.specialization ?? 'Specialist',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        if (doctor.experience != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            '${doctor.experience}+ years experience',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('View ${doctor.name}\'s profile'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey,
                                      size: 16,
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
                ],

                const SizedBox(height: 32),

                // About Section
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
                ),

                const SizedBox(height: 24),

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

                // Static Treatment Categories (since not in API response)
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: treatmentCategories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
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

                // Additional Info Section (removed since not in API)

                // Static Additional Information
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'What to Expect:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Our professional team will guide you through every step of your treatment journey, ensuring comfort, safety, and optimal results.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

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
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
  final String bookings;
  final bool isOnSale;
  final bool isTopService;
  final VoidCallback onBook;

  const ServiceCard({
    Key? key,
    required this.name,
    required this.price,
    required this.description,
    required this.bookings,
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                price,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
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
          Row(
            children: [
              ElevatedButton(
                onPressed: onBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    bookings,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    ),
  );
}