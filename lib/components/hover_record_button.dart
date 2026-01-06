import 'package:flutter/material.dart';
import 'package:signtalk/utils/constants.dart';

class HoverRecordButton extends StatefulWidget {
  const HoverRecordButton({super.key});

  @override
  State<HoverRecordButton> createState() => _HoverRecordButtonState();
}

class _HoverRecordButtonState extends State<HoverRecordButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // TODO: handle record action
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:
                isHovered
                    ? ColorsConstant.accent.withOpacity(0.85) // deepened
                    : ColorsConstant.accent,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_circle_rounded, color: Colors.black),
                SizedBox(width: 5),
                Text(
                  'Record Patient',
                  style: FontsConstant.buttonText.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
