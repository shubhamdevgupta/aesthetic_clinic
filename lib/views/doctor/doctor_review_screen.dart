import 'package:flutter/material.dart';

class DoctorReviewScreen extends StatefulWidget {
  const DoctorReviewScreen({Key? key}) : super(key: key);

  @override
  State<DoctorReviewScreen> createState() => _DoctorReviewScreenState();
}

class _DoctorReviewScreenState extends State<DoctorReviewScreen> {
  int selectedRating = 0;

  final List<Map<String, dynamic>> reviews = [
    {
      'name': 'John Doberman',
      'date': 'Mar 14 2025',
      'rating': 5,
      'comment': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'avatar': Colors.purple.shade800,
    },
    {
      'name': 'John Doberman',
      'date': 'Mar 14 2025',
      'rating': 5,
      'comment': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'avatar': Colors.purple.shade800,
    },
    {
      'name': 'John Doberman',
      'date': 'Mar 14 2025',
      'rating': 5,
      'comment': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'avatar': Colors.purple.shade800,
    },
  ];

  Widget buildStarRating(int rating, {bool isInteractive = false, double size = 20}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: isInteractive ? () {
            setState(() {
              selectedRating = index + 1;
            });
          } : null,
          child: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.red,
            size: size,
          ),
        );
      }),
    );
  }

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
      ),
      body: SingleChildScrollView(
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
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80'
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Doctor Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dr. Loma Zaher Aldeen',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Specialist Dermatologist &\nAesthetic Medicine Expert',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Experience: 6+ Years',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Overall Rating Section
            Row(
              children: [
                buildStarRating(5, size: 24),
                const SizedBox(width: 8),
                const Text(
                  '4.9 Ratings',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // User Rating Section
            buildStarRating(selectedRating, isInteractive: true, size: 28),

            const SizedBox(height: 16),

            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            // Submit Review Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit review
                  if (selectedRating > 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Review submitted with $selectedRating stars!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a rating first!'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Submit Review',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Existing Reviews Section
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            // Reviews List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ReviewCard(
                  name: review['name'],
                  date: review['date'],
                  rating: review['rating'],
                  comment: review['comment'],
                  avatarColor: review['avatar'],
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String name;
  final String date;
  final int rating;
  final String comment;
  final Color avatarColor;

  const ReviewCard({
    Key? key,
    required this.name,
    required this.date,
    required this.rating,
    required this.comment,
    required this.avatarColor,
  }) : super(key: key);

  Widget buildStarRating(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.red,
          size: 16,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: avatarColor,
              child: Text(
                name.split(' ').map((n) => n[0]).join('').toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            buildStarRating(rating),
          ],
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 52),
          child: Text(
            comment,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}