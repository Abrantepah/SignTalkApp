import 'package:flutter/material.dart';
import 'package:signtalk/components/customAppBar.dart';
import 'package:signtalk/utils/constants.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({super.key});

  @override
  State<PatientPage> createState() => _PatientPageState();
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
                child: Image.asset('assets/images/sign2.jpg', fit: BoxFit.fill),
              ),

              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.6),

                        Colors.greenAccent.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Row(
            children: [
              // MAIN VIDEO AREA
              Expanded(flex: 7, child: _buildVideoArea()),

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
Widget _buildVideoArea() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        // VIDEO PLAYER
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.white.withOpacity(0.5),
              child: Center(
                child: Text(
                  "Patient Camera Feed",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // VIDEO CONTROLS
        Row(
          children: [
            _liveBadge(),
            const Spacer(),
            Icon(Icons.play_arrow, color: Colors.white),
            const SizedBox(width: 12),
            Icon(Icons.volume_up, color: Colors.white),
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
      color: Colors.purple,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text("LIVE", style: FontsConstant.buttonText),
  );
}

// SIDE PANEL WITH CHAT AND INFO
Widget _buildSidePanel() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2F48),
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
                  Icon(
                    Icons.settings_remote_sharp,
                    color: Colors.green,
                    size: 25,
                  ),
                ],
              ),
              //use this to refresh chat
              Icon(Icons.sync_outlined, color: Colors.white, size: 25),
            ],
          ),

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
              ),
              _videoThumbnail(
                "Please repeat the sign",
                'assets/images/laboratory.jpg',
              ),
              _videoThumbnail(
                "Please repeat the sign",
                'assets/images/laboratory.jpg',
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

//VIDEO THUMBNAIL WIDGET
Widget _videoThumbnail(String title, thumbnailPath) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            thumbnailPath,
            height: 100,
            width: 160,
            fit: BoxFit.cover,
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: FontsConstant.headingMedium.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                "Patient: 1",
                style: FontsConstant.bodyMedium.copyWith(color: Colors.white70),
              ),
              Text(
                "Duration: 2 mins",
                style: FontsConstant.bodyMedium.copyWith(color: Colors.white70),
              ),
              Text(
                'Time: 10:30 AM',
                style: FontsConstant.bodyMedium.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
