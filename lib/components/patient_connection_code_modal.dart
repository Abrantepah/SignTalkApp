import 'package:flutter/material.dart';
import 'package:signtalk/utils/constants.dart';

class PatientConnectCodeModal extends StatelessWidget {
  const PatientConnectCodeModal();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            margin: const EdgeInsets.only(top: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorsConstant.darkPurple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  "Connect to Doctor's Device",
                  style: FontsConstant.headingMedium.copyWith(
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Enter the connection code shown on the doctor’s device",
                  textAlign: TextAlign.center,
                  style: FontsConstant.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 20),

                // Code input
                TextField(
                  textAlign: TextAlign.center,
                  style: FontsConstant.bodyMedium.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                    letterSpacing: 6,
                  ),
                  maxLength: 6,
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "••••••",
                    hintStyle: TextStyle(color: Colors.white30),
                    filled: true,
                    fillColor: const Color(0xFF1F2235),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel", style: FontsConstant.buttonText),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Validate & connect via socket
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsConstant.softPurple,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      child: Text("Connect", style: FontsConstant.buttonText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
