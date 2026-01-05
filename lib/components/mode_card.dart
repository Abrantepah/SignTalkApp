import 'package:flutter/material.dart';
import 'package:signtalk/navigation%20pages/healthWorker%20pages/doctor_page.dart';
import 'package:signtalk/navigation%20pages/patient%20pages/patient_page.dart';
import 'package:signtalk/utils/constants.dart';
import 'package:signtalk/utils/page_transition_direction.dart';
import 'package:signtalk/utils/slide_page_route.dart';

class ModeCard extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final String mode;

  const ModeCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.mode,
  });

  @override
  State<ModeCard> createState() => _ModeCardState();
}

class _ModeCardState extends State<ModeCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;
    final double cardHeight = isMobile ? 240 : 270;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          if (widget.mode == "doctor") {
            Navigator.push(
              context,
              SlidePageRoute(
                page: Translation(category: widget.mode),
                direction: PageTransitionDirection.up,
              ),
            );
            return;
          }
          if (widget.mode == "patient") {
            Navigator.push(
              context,
              SlidePageRoute(
                page: PatientPage(),
                direction: PageTransitionDirection.down,
              ),
            );
            return;
          }
          if (widget.mode == "learner") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Translation(category: widget.mode),
              ),
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: cardHeight,
          transform: Matrix4.identity()..scale(_isHovered ? 1.03 : 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.3 : 0.15),
                blurRadius: _isHovered ? 20 : 10,
                offset: const Offset(0, 8),
              ),
            ],
            image: DecorationImage(
              image: AssetImage(widget.image),
              fit: BoxFit.cover, // ✅ image covers entire card
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:
                    _isHovered
                        ? [
                          Colors.black.withOpacity(0.35),
                          Colors.black.withOpacity(0.75),
                        ]
                        : [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.4),
                        ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: FontsConstant.headingMedium.copyWith(
                      fontSize: isMobile ? 16 : 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: FontsConstant.bodyMedium.copyWith(
                      fontSize: isMobile ? 12 : 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
