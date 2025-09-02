import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Appcolor.dart';

class CircleShimmer extends StatelessWidget {
  final double size;

  const CircleShimmer({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(
        strokeWidth: 2,
        color: Appcolor.mehrun,
      ),
    );
  }
}