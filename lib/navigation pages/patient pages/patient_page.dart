import 'package:flutter/material.dart';
import 'package:signtalk/components/patient_connection_code_modal.dart';
import 'package:signtalk/utils/constants.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({super.key});

  @override
  State<PatientPage> createState() => _PatientPageState();
}

void showConnectCodeModal(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Connect",
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return const PatientConnectCodeModal();
    },
    transitionBuilder: (_, animation, __, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}

class _PatientPageState extends State<PatientPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/sign2.jpg',
                  fit: BoxFit.fill,
                  opacity: AlwaysStoppedAnimation(0.8),
                ),
              ),

              // Gradient overlay
              // Positioned.fill(
              //   child: Container(
              //     decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //         begin: Alignment.topCenter,
              //         end: Alignment.bottomCenter,
              //         colors: [
              //           Colors.white.withOpacity(0.6),

              //           Colors.greenAccent.withOpacity(0.4),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),

          Row(
            children: [
              // MAIN VIDEO AREA
              Expanded(flex: 7, child: _buildVideoArea(context)),

              // SIDE CHAT PANEL
              // SIDE CHAT PANEL
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    // TOP CONTAINER (Chat / Translation)
                    Expanded(flex: 5, child: _buildSidePanel()),

                    // BOTTOM CONTAINER (Black panel)
                    Expanded(flex: 3, child: _buildRecentVideos()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// SIDE VIDEO PANEL
Widget _buildVideoArea(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        // VIDEO PLAYER WITH CAPTION
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Video / Avatar
                Positioned.fill(
                  child: Container(
                    color: Colors.white.withOpacity(0.5),
                    child: Center(
                      // child: Image.asset(
                      //   'assets/images/avatar_thumbnail.png',
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                ),

                // TOP CAPTION OVERLAY
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Translated Sign Output",
                        style: FontsConstant.bodyMedium.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // VIDEO CONTROLS
        Row(
          children: [
            _liveBadge(),
            const SizedBox(width: 12),
            _connectionButton(context),
            const Spacer(),
            const Icon(Icons.play_arrow, color: Colors.white),
            const SizedBox(width: 12),
            const Icon(Icons.fullscreen, color: Colors.white),
          ],
        ),
      ],
    ),
  );
}

// LIVE BADGE WIDGET
Widget _liveBadge() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: ColorsConstant.safeRed,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text("LIVE", style: FontsConstant.buttonText),
      ],
    ),
  );
}

Widget _connectionButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      // Handle connection logic here
      showConnectCodeModal(context);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorsConstant.darkPurple,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    child: Row(
      children: [
        Icon(Icons.link, color: Colors.white),
        const SizedBox(width: 6),
        Text(
          "Connect to Doctor",
          style: FontsConstant.buttonText.copyWith(fontSize: 16),
        ),
      ],
    ),
  );
}

// SIDE PANEL WITH CHAT AND INFO
Widget _buildSidePanel() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsConstant.darkPurple,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Live Chat",
                    style: FontsConstant.headingLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  //show this if only there is a connection between doctor and patient devices
                  Icon(Icons.diversity_3, color: Colors.green, size: 25),
                ],
              ),
              //use this to refresh chat
              Icon(Icons.sync_outlined, color: Colors.white, size: 25),
            ],
          ),
          const SizedBox(height: 16),
          //divider
          Container(height: 1, color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 16),

          // CHAT / TRANSLATION FEED
          Expanded(
            child: ListView(
              children: [
                _chatBubble("Doctor", "Please repeat the sign"),
                _chatBubble("You", "Translation: Headache"),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// CHAT BUBBLE WIDGET
Widget _chatBubble(String sender, String message) {
  final bool isDoctor = sender == "Doctor";

  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Image.asset(
              isDoctor
                  ? 'assets/images/doctor_icon.jpg'
                  : 'assets/images/patient_icon.jpg',
              height: 56,
              width: 56,
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Message content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sender,
                style: FontsConstant.bodyMedium.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color:
                      isDoctor
                          ? const Color(0xFF6C5CE7) // Doctor bubble
                          : const Color(0xFF1F2235), // Patient bubble
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  message,
                  style: FontsConstant.bodyMedium.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// // MESSAGE INPUT FIELD WIDGET
// Widget _messageInput() {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 12),
//     decoration: BoxDecoration(
//       color: const Color(0xFF1F2235),
//       borderRadius: BorderRadius.circular(30),
//     ),
//     child: Row(
//       children: [
//         Expanded(
//           child: TextField(
//             style: const TextStyle(color: Colors.white),
//             decoration: const InputDecoration(
//               hintText: "Type message to patient...",
//               hintStyle: TextStyle(color: Colors.white38),
//               border: InputBorder.none,
//             ),
//           ),
//         ),
//         Icon(Icons.send, color: Colors.purple),
//       ],
//     ),
//   );
// }

// RECENT VIDEOS WIDGET
Widget _buildRecentVideos() {
  return Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Videos",
          style: FontsConstant.headingLarge.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 12),

        // SCROLLABLE LIST
        Expanded(
          child: ListView(
            children: [
              _videoThumbnail(
                "Please repeat the sign",
                'assets/images/laboratory.jpg',
                "4 mins",
                1,
                "10:36 AM",
              ),
              _videoThumbnail(
                "Where is the hospital entrance?",
                'assets/images/laboratory.jpg',
                "2 mins",
                1,
                "10:39 AM",
              ),
              _videoThumbnail(
                "Have you taken your medication?",
                'assets/images/laboratory.jpg',
                "2 mins",
                1,
                "10:28 AM",
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _videoThumbnail(
  String title,
  String thumbnailPath,
  String duration,
  int patientCount,
  String time,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thumbnail
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            thumbnailPath,
            height: 100,
            width: 160,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(width: 10),

        // ✅ THIS IS THE FIX
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: FontsConstant.headingMedium.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Duration: $duration",
                style: FontsConstant.bodyMedium.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 3),
              Text(
                "Patient: #$patientCount",
                style: FontsConstant.bodyMedium.copyWith(color: Colors.white70),
              ),
              Text(
                'Time: $time',
                style: FontsConstant.bodyMedium.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
