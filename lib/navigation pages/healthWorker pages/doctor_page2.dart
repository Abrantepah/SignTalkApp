import 'package:flutter/material.dart';
import 'package:signtalk/components/customAppBar.dart';

class DoctorPage2 extends StatefulWidget {
  const DoctorPage2({super.key});

  @override
  State<DoctorPage2> createState() => _DoctorPage2State();
}

class _DoctorPage2State extends State<DoctorPage2> {
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
                        Colors.black.withOpacity(0.6),

                        Colors.deepPurple.withOpacity(0.7),
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
    child: const Text(
      "LIVE",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        color: const Color(0xFF2C2F48),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Live Translation",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // CHAT / TRANSLATION FEED
          Expanded(
            child: ListView(
              children: [
                _chatBubble("Doctor", "Please repeat the sign"),
                _chatBubble("System", "Translation: Headache"),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // INPUT FIELD
          _messageInput(),
        ],
      ),
    ),
  );
}

// RECENT VIDEOS WIDGET
Widget _buildRecentVideos() {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
    child: Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: const Color(0xFF2C2F48),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Text("Connection Status", style: TextStyle(color: Colors.white)),
      ),
    ),
  );
}

// CHAT BUBBLE WIDGET
Widget _chatBubble(String sender, String message) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sender, style: TextStyle(color: Colors.white54)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1F2235),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

// MESSAGE INPUT FIELD WIDGET
Widget _messageInput() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: const Color(0xFF1F2235),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Type message to patient...",
              hintStyle: TextStyle(color: Colors.white38),
              border: InputBorder.none,
            ),
          ),
        ),
        Icon(Icons.send, color: Colors.purple),
      ],
    ),
  );
}
