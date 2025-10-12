import 'package:flutter/material.dart';
import 'package:signtalk/navigation%20pages/Translation.dart';
import 'package:signtalk/utils/constants.dart'; // assuming your constants file is here

class ThemeCard extends StatefulWidget {
  final String image;
  final String title;
  final String description;

  const ThemeCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  State<ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<ThemeCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Translation()),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors:
                    _isHovered
                        ? [ColorsConstant.primary, ColorsConstant.extra]
                        : [ColorsConstant.secondary, ColorsConstant.extra],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      _isHovered
                          ? ColorsConstant.primary.withOpacity(0.35)
                          : ColorsConstant.secondary.withOpacity(0.2),
                  blurRadius: _isHovered ? 18 : 8,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Transform.scale(
              scale: _isHovered ? 1.03 : 1.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          widget.image,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: FontsConstant.headingMedium.copyWith(
                            color: ColorsConstant.accent,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.description,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: FontsConstant.bodyMedium.copyWith(
                            color: ColorsConstant.tertiary.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
