import 'package:flutter/material.dart';
import 'package:signtalk/components/app_side_drawer.dart';
import 'package:signtalk/components/customAppBar.dart';
import 'package:signtalk/components/mode_card.dart';
import 'package:signtalk/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Mode {
  final String image;
  final String title;
  final String description;
  final String usermode;

  Mode({
    required this.image,
    required this.title,
    required this.description,
    required this.usermode,
  });
}

class UserMode extends StatelessWidget {
  UserMode({super.key});

  final List<Mode> userModes = [
    Mode(
      image: "assets/images/doctor_mode.png",
      title: "Doctor",
      description:
          "Connect with patients, communicate effectively, and provide quality care using sign language.",
      usermode: "doctor",
    ),
    Mode(
      image: "assets/images/patient_mode.png",
      title: "Patient",
      description:
          "Access healthcare services and receive medical care using sign language.",
      usermode: "patient",
    ),
    Mode(
      image: "assets/images/learner_mode.png",
      title: "Learner",
      description: "Learn sign language and improve communication skills.",
      usermode: "learner",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1000;
    final bool isDesktop = width >= 1000;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      endDrawer: const AppSideDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal:
              isDesktop
                  ? 60
                  : isTablet
                  ? 32
                  : 16,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Header
            Text(
              "SignTalk for Health Workers",
              textAlign: TextAlign.center,
              style: FontsConstant.headingLarge.copyWith(
                fontSize: isMobile ? 26 : 35,
                color: ColorsConstant.textColor,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Communication in sign language should be easy and accessible for everyone.\n"
              "Who are you using SignTalk as?",
              textAlign: TextAlign.center,
              style: FontsConstant.headingMedium.copyWith(
                fontSize: isMobile ? 14 : 20,
                color: ColorsConstant.textColor,
              ),
            ),

            const SizedBox(height: 80),

            // 🔹 Responsive Modes Layout
            _buildModesLayout(isMobile, isTablet, isDesktop),

            const SizedBox(height: 80),

            const DesktopTabletBanner(),
          ],
        ),
      ),
    );
  }

  // 🔹 Layout Builder
  Widget _buildModesLayout(bool isMobile, bool isTablet, bool isDesktop) {
    if (isMobile) {
      // ✅ Mobile: stacked layout
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: userModes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 20,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final mode = userModes[index];
          return ModeCard(
            image: mode.image,
            title: mode.title,
            description: mode.description,
            mode: mode.usermode,
          );
        },
      );
    }

    // ✅ Tablet & Desktop: staggered layout
    final double middleOffset = isDesktop ? 80 : 50;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Left card
        Expanded(child: _buildModeCard(userModes[0])),

        const SizedBox(width: 24),

        // Middle card (offset)
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: middleOffset),
            child: _buildModeCard(userModes[1]),
          ),
        ),

        const SizedBox(width: 24),

        // Right card
        Expanded(child: _buildModeCard(userModes[2])),
      ],
    );
  }

  Widget _buildModeCard(Mode mode) {
    return ModeCard(
      image: mode.image,
      title: mode.title,
      description: mode.description,
      mode: mode.usermode,
    );
  }
}

class DesktopTabletBanner extends StatelessWidget {
  const DesktopTabletBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isTablet = width >= 600 && width < 1000;
    final bool isDesktop = width >= 1000;

    if (!isTablet && !isDesktop) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 32,
        vertical: 50,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF3E7E3), Color(0xFFE7EEF6)],
        ),
      ),
      child: Column(
        children: [
          Text(
            "Discover, Support, and Dive Deeper into \nSignTalkGH!",
            textAlign: TextAlign.center,
            style: FontsConstant.headingLarge.copyWith(
              fontSize: isDesktop ? 30 : 32,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            "SignTalkGH is a Ghana-based platform that uses AI to interpret Ghanaian Sign Language. "
            "It bridges communication gaps between Deaf individuals and professionals, especially in healthcare.",
            textAlign: TextAlign.center,
            style: FontsConstant.bodyMedium.copyWith(
              fontSize: isDesktop ? 18 : 16,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 30),

          Text(
            "Partners & Sponsors",
            style: FontsConstant.headingMedium.copyWith(
              fontSize: isDesktop ? 22 : 20,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset("assets/images/partners.png", height: 120),
          ),

          const SizedBox(height: 30),

          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () async {
                  final Uri url = Uri.parse(
                    "https://rail.knust.edu.gh/sign-talk/",
                  );
                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  )) {
                    // Handle error if URL can't be launched
                    print('Could not launch $url');
                  }
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Learn More"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
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
