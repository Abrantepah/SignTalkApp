import 'package:flutter/material.dart';
import 'package:signtalk/navigation%20pages/healthWorker%20pages/doctor_page.dart';
import 'package:signtalk/utils/constants.dart';

class ThemeCard extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final String category;

  const ThemeCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.category,
  });

  @override
  State<ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<ThemeCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;

    // Card height responsiveness
    final double cardHeight = isMobile ? 240 : 270;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Translation(category: widget.category),
            ),
          );
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: cardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors:
                  _isHovered
                      ? [ColorsConstant.primary, ColorsConstant.extra]
                      : [ColorsConstant.secondary, ColorsConstant.extra],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.25 : 0.15),
                blurRadius: _isHovered ? 16 : 8,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Transform.scale(
            scale: _isHovered ? 1.02 : 1.0,
            child: Column(
              children: [
                // ✅ Image (fixed height)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    widget.image,
                    height: isMobile ? 280 : 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // ✅ Compact Content Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FontsConstant.headingMedium.copyWith(
                            fontSize: isMobile ? 16 : 18,
                            color: ColorsConstant.accent,
                          ),
                        ),

                        const SizedBox(height: 5),

                        // Description (shortened)
                        Text(
                          widget.description,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: FontsConstant.bodyMedium.copyWith(
                            fontSize: isMobile ? 12 : 14,
                            color: ColorsConstant.tertiary.withOpacity(0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
