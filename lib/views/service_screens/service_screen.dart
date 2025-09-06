import 'package:flutter/material.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServiceScreen> {
  List<Map<String, dynamic>> mainCategories = [];
  List<Map<String, dynamic>> featuredServices = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  // Replace this method with your API calls
  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    // TODO: Replace with actual API calls
    // Example structure for your data:

    // Main categories data structure
    mainCategories = [
      {
        'id': 1,
        'name': 'Laser Hair\nRemoval',
        'image': 'assets/laser_hair.png', // Replace with your image URLs
      },
      {
        'id': 2,
        'name': 'Dermatology and\nAesthetics',
        'image': 'assets/dermatology.png',
      },
      {
        'id': 3,
        'name': 'Dental\nServices',
        'image': 'assets/dental.png',
      },
      {
        'id': 4,
        'name': 'Hijama\nTherapy',
        'image': 'assets/hijama.png',
      },
    ];

    // Featured services data structure
    featuredServices = [
      {
        'id': 1,
        'name': 'Injectables',
        'startingPrice': 'AED 100',
        'image': 'assets/injectables.jpg',
      },
      {
        'id': 2,
        'name': 'Skin Tightening',
        'startingPrice': 'AED 200',
        'image': 'assets/skin_tightening.jpg',
      },
      {
        'id': 3,
        'name': 'Deep Cleansing',
        'startingPrice': 'AED 150',
        'image': 'assets/deep_cleansing.jpg',
      },
      {
        'id': 4,
        'name': 'Acne Treatment',
        'startingPrice': 'AED 120',
        'image': 'assets/acne_treatment.jpg',
      },
    ];

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Main Categories Section
                const Text(
                  'Our Main Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B2D8E),
                  ),
                ),
                const SizedBox(height: 20),

                // Main Categories Horizontal Scroll
                _buildMainCategoriesGrid(),

                const SizedBox(height: 30),

                // Featured Services Grid (2x2 with horizontal scroll)
                _buildFeaturedServicesGrid(),

                const SizedBox(height: 100), // Space for bottom navigation
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainCategoriesGrid() {
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
          itemCount: mainCategories.length,
          itemBuilder: (context, index) {
            final category = mainCategories[index];
            return Container(
              margin: EdgeInsets.only(
                left: 8,
                right: index < mainCategories.length - 1 ? 8 : 8,
              ),
              width: 90,
              child: _buildCategoryCard(
                category['name'],
                category['image'],
                    () {
                  // TODO: Navigate to category details
                  print('Tapped on ${category['name']}');
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Placeholder when image fails to load
                    return Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image,
                        color: Colors.grey[400],
                        size: 25,
                      ),
                    );
                  },
                ),
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

  Widget _buildFeaturedServicesGrid() {
    return SizedBox(
      height: 450, // Fixed height for horizontal scroll
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: (featuredServices.length / 2).ceil(), // Number of columns
        itemBuilder: (context, columnIndex) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.48, // Card width
            margin: EdgeInsets.only(
              right: columnIndex < (featuredServices.length / 2).ceil() - 1 ? 12 : 0,
            ),
            child: Column(
              children: [
                // First card in column
                if (columnIndex * 2 < featuredServices.length)
                  Expanded(
                    child: _buildFeaturedServiceCard(
                      featuredServices[columnIndex * 2]['name'],
                      featuredServices[columnIndex * 2]['startingPrice'],
                      featuredServices[columnIndex * 2]['image'],
                          () {
                        print('Tapped on ${featuredServices[columnIndex * 2]['name']}');
                      },
                    ),
                  ),
                const SizedBox(height: 12),
                // Second card in column
                if (columnIndex * 2 + 1 < featuredServices.length)
                  Expanded(
                    child: _buildFeaturedServiceCard(
                      featuredServices[columnIndex * 2 + 1]['name'],
                      featuredServices[columnIndex * 2 + 1]['startingPrice'],
                      featuredServices[columnIndex * 2 + 1]['image'],
                          () {
                        print('Tapped on ${featuredServices[columnIndex * 2 + 1]['name']}');
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedServiceCard(String title, String price, String imagePath, VoidCallback onTap,) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Background Image
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Placeholder when image fails to load
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image,
                        color: Colors.grey[500],
                        size: 50,
                      ),
                    );
                  },
                ),
              ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Starting From $price',
                      style: const TextStyle(
                        color: Colors.white,
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

  // Method to refresh data - call this when you want to reload from API
  Future<void> refreshData() async {
    await loadData();
  }
}