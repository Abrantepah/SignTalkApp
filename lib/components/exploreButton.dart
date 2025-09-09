import 'package:flutter/material.dart';

Widget exploreButton() {
  return Container(
    width: 150,
    height: 150,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: const RadialGradient(
        colors: [Colors.white, Color(0xFFE3F2FD)], // light white/blue glow
        center: Alignment.center,
        radius: 0.9,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.play_arrow, size: 28, color: Colors.black87),
          SizedBox(height: 6),
          Text(
            "Explore Demo",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    ),
  );
}
