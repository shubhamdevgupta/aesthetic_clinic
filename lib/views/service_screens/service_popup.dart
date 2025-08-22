import 'package:flutter/material.dart';

class ServicePopup extends StatefulWidget {
  final String title;
  final String description;
  final String price;
  final String duration;
  final String imageUrl;

  const ServicePopup({
    Key? key,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<ServicePopup> createState() => _ServicePopupState();
}

class _ServicePopupState extends State<ServicePopup> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Duration
            Text(
              widget.duration,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            // Title
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF660033),
              ),
            ),

            const SizedBox(height: 4),

            // Description
            Text(
              widget.description,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 12),

            // Price
            Text(
              "AED ${widget.price}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            const Divider(height: 24),

            // Quantity + Add Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Quantity Selector
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (quantity > 0) {
                          setState(() => quantity--);
                        }
                      },
                    ),
                    Text(
                      quantity.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() => quantity++);
                      },
                    ),
                  ],
                ),

                // Add to Cart Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF660033),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // handle add to cart logic
                  },
                  child: Text(
                    "AED ${(int.parse(widget.price) * quantity).toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
