import 'package:flutter/material.dart';

class CartIconButton extends StatelessWidget {
  final int itemCount;
  final VoidCallback onPressed;

  const CartIconButton({
    Key? key,
    required this.itemCount,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // White box with mehroon icon
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // background
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Color(0xFF660033), // mehroon color
            ),
            onPressed: onPressed,
          ),
        ),

        // 🔴 Badge
        if (itemCount > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Color(0xFF660033), // mehroon badge
                shape: BoxShape.circle,
              ),
              constraints: BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Center(
                child: Text(
                  '$itemCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
