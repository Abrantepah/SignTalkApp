import 'dart:math';
import 'package:flutter/material.dart';

class SolarSystemAnimation extends StatefulWidget {
  const SolarSystemAnimation({super.key});

  @override
  _SolarSystemAnimationState createState() => _SolarSystemAnimationState();
}

class _SolarSystemAnimationState extends State<SolarSystemAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset _calculateOrbitOffset(double radius, double angle, Offset center) {
    final x = center.dx + radius * cos(angle);
    final y = center.dy + radius * sin(angle);
    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxSize = min(constraints.maxWidth, constraints.maxHeight);

        final double centerSize = maxSize * 0.35; // central circle
        final double smallSize = maxSize * 0.12; // orbiting circles

        final List<double> orbitRadii = [
          maxSize * 0.25,
          maxSize * 0.35,
          maxSize * 0.45,
        ];

        final center = Offset(
          constraints.maxWidth / 2,
          constraints.maxHeight / 2,
        );

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double angle = _controller.value * 2 * pi;

            return Stack(
              children: [
                // Orbiting Rings
                CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: OrbitPainter(center: center, radii: orbitRadii),
                ),

                // Central Circle
                Positioned(
                  left: center.dx - centerSize / 2,
                  top: center.dy - centerSize / 2,
                  child: Container(
                    width: centerSize,
                    height: centerSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/avatar_icon.png'),
                        fit: BoxFit.cover,
                        opacity: 0.9,
                      ),
                    ),
                  ),
                ),

                // First ring: 5 small circles
                for (int i = 0; i < 5; i++)
                  Positioned(
                    left:
                        _calculateOrbitOffset(
                          orbitRadii[0],
                          angle + i * 2 * pi / 5,
                          center,
                        ).dx -
                        smallSize / 2,
                    top:
                        _calculateOrbitOffset(
                          orbitRadii[0],
                          angle + i * 2 * pi / 5,
                          center,
                        ).dy -
                        smallSize / 2,
                    child: Container(
                      width: smallSize,
                      height: smallSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/action${i + 1}.jpg'),
                          fit: BoxFit.cover,
                          opacity: 0.6,
                        ),
                      ),
                    ),
                  ),

                // Second ring: 4 small circles
                for (int i = 0; i < 4; i++)
                  Positioned(
                    left:
                        _calculateOrbitOffset(
                          orbitRadii[1],
                          -angle + i * 2 * pi / 4,
                          center,
                        ).dx -
                        smallSize / 2,
                    top:
                        _calculateOrbitOffset(
                          orbitRadii[1],
                          -angle + i * 2 * pi / 4,
                          center,
                        ).dy -
                        smallSize / 2,
                    child: Container(
                      width: smallSize,
                      height: smallSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/action${i + 6}.jpg'),
                          fit: BoxFit.cover,
                          opacity: 0.6,
                        ),
                      ),
                    ),
                  ),

                // Third ring: 3 small circles
                for (int i = 0; i < 3; i++)
                  Positioned(
                    left:
                        _calculateOrbitOffset(
                          orbitRadii[2],
                          angle + i * 2 * pi / 3,
                          center,
                        ).dx -
                        smallSize / 2,
                    top:
                        _calculateOrbitOffset(
                          orbitRadii[2],
                          angle + i * 2 * pi / 3,
                          center,
                        ).dy -
                        smallSize / 2,
                    child: Container(
                      width: smallSize,
                      height: smallSize,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/action${i + 10}.jpg',
                          ),
                          fit: BoxFit.cover,
                          opacity: 0.2,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class OrbitPainter extends CustomPainter {
  final Offset center;
  final List<double> radii;

  OrbitPainter({required this.center, required this.radii});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white54
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    for (double radius in radii) {
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
