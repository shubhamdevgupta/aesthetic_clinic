import 'package:flutter/material.dart';

import '../../utils/Appcolor.dart';

class HomeBasedScreen extends StatefulWidget {
  const HomeBasedScreen({super.key});

  @override
  State<HomeBasedScreen> createState() => _HomeBasedScreenState();
}

class _HomeBasedScreenState extends State<HomeBasedScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/icons/ic_coming.png"),
          const SizedBox(height: 18),
          const Text(
            "Coming Soon...",
            style: TextStyle(
              color: Appcolor.mehrun,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
