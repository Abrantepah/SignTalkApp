import 'package:flutter/material.dart';
import 'package:signtalk/components/doctor_connection_code_modal.dart';
import 'package:signtalk/components/hover_record_button.dart';
import 'package:signtalk/components/model_card.dart';
import 'package:signtalk/utils/constants.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({super.key});

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

final List<Map<String, String>> modelCards = [
  {
    'image': 'assets/images/general_model.jpg',
    'title': 'General Model (ST-2.0)',
    'description':
        'Handles common hospital conversations between patients and healthcare workers.',
  },
  {
    'image': 'assets/images/diagnosis_model.jpg',
    'title': 'Clinical Diagnosis Model (ST-1.0)',
    'description':
        'Focused on medical, symptom, and diagnosis-related sign language communication.',
  },
  {
    'image': 'assets/images/gtkp_model.jpg',
    'title': 'Patient Navigation & Interaction Model (ST-1.1)',
    'description':
        'Supports greetings, directions, and general hospital interactions outside diagnosis.',
  },
];

int selectedModelIndex = 0; //default selection of model card

void showConnectCodeModal(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Connect",
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return const DoctorConnectCodeModal();
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

class _DoctorPageState extends State<DoctorPage> {
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
                    Expanded(flex: 6, child: _buildSidePanel()),

                    // BOTTOM CONTAINER (Black panel)
                    Expanded(flex: 2, child: _buildControlPanel()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // CONTROL PANEL WIDGET
  Widget _buildControlPanel() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorsConstant.darkPurple,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP BUTTON
            HoverRecordButton(),

            const SizedBox(height: 16),

            // MODEL CARDS
            AspectRatio(
              aspectRatio: 3.5,
              child: Row(
                children: List.generate(modelCards.length, (index) {
                  final bool isSelected = selectedModelIndex == index;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index == modelCards.length - 1 ? 0 : 8,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedModelIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? ColorsConstant.accent
                                      : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow:
                                isSelected
                                    ? [
                                      BoxShadow(
                                        color: ColorsConstant.accent
                                            .withOpacity(0.4),
                                        blurRadius: 12,
                                      ),
                                    ]
                                    : [],
                          ),
                          child: ModelCard(
                            imagePath: modelCards[index]['image']!,
                            title: modelCards[index]['title']!,
                            description: modelCards[index]['description']!,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
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

          _messageInput(),
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
