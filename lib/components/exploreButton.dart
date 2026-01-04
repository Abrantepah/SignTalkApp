import 'package:flutter/material.dart';
import 'package:signtalk/utils/constants.dart';

Widget exploreButton() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          colors: [
            ColorsConstant.extra,
            ColorsConstant.primary,
          ], // light white/blue glow
          center: Alignment.topLeft,
          radius: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Text(
          "Explore Now",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    ),
  );
}
