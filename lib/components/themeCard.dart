import 'package:flutter/material.dart';

class ThemeCard extends StatelessWidget {
  final String title;
  final String assetImage; // <-- new image path
  final String buttonName;
  final VoidCallback? onPressed;

  const ThemeCard({
    super.key,
    required this.title,
    required this.assetImage,
    required this.buttonName,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Image widget
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                assetImage,
                fit: BoxFit.cover,
                height: 150, // set fixed height (optional)
                width: double.infinity,
              ),
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed ?? () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  buttonName,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
