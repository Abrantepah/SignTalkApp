import 'package:flutter/material.dart';
import 'package:signtalk/utils/constants.dart';

class ModelCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String description;

  const ModelCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  State<ModelCard> createState() => _ModelCardState();
}

class _ModelCardState extends State<ModelCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          final rotate = Tween(begin: 1.0, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotate,
            child: child,
            builder: (context, child) {
              final angle = rotate.value * 3.1416;
              return Transform(
                transform: Matrix4.rotationY(angle),
                alignment: Alignment.center,
                child: child,
              );
            },
          );
        },
        child: isHovered ? _buildBack() : _buildFront(),
      ),
    );
  }

  /// FRONT SIDE (Image + Overlay + Title)
  Widget _buildFront() {
    return Container(
      key: const ValueKey("front"),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(widget.imagePath, fit: BoxFit.cover),
            ),

            // Dark overlay
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),

            // Title
            Center(
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: FontsConstant.headingLarge.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// BACK SIDE (Explanation)
  Widget _buildBack() {
    return Container(
      key: const ValueKey("back"),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2235),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12)],
      ),
      child: Center(
        child: Text(
          widget.description,
          textAlign: TextAlign.center,
          style: FontsConstant.bodyMedium.copyWith(
            color: Colors.white,
            fontSize: 9,
          ),
        ),
      ),
    );
  }
}
