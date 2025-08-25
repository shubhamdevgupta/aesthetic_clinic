import 'package:flutter/material.dart';

class HomeBasedScreen extends StatefulWidget {
  const HomeBasedScreen({super.key});

  @override
  State<HomeBasedScreen> createState() => _HomeBasedScreenState();
}

class _HomeBasedScreenState extends State<HomeBasedScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 48),
        Center(child: Image.asset("assets/icons/ic_coming.png")),
        SizedBox(height: 18),
        Text(
          "Coming Soon...",
          style: TextStyle(
            color: Color(0xFF660033),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
