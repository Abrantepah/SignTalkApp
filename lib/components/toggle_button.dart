import 'package:flutter/material.dart';
import 'package:signtalk/utils/constants.dart';

class ToggleButtonDemo extends StatefulWidget {
  const ToggleButtonDemo({super.key});

  @override
  _ToggleButtonDemoState createState() => _ToggleButtonDemoState();
}

class _ToggleButtonDemoState extends State<ToggleButtonDemo> {
  int selectedIndex = 0; // Default selection: Customer

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 210,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // ✅ Sliding background highlight
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment:
                selectedIndex == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
            child: Container(
              width: 100,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorsConstant.extra, ColorsConstant.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          // ✅ Foreground interactive buttons
          Row(
            children: [
              // Customer
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Text -> Sign",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            selectedIndex == 0 ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),

              // Servian
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Sign -> Text',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            selectedIndex == 1 ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
