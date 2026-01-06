import 'package:flutter/material.dart';
import 'package:signtalk/components/app_side_drawer.dart';
import 'package:signtalk/components/customAppBar.dart';
import 'package:signtalk/components/exploreButton.dart';
import 'package:signtalk/components/infoCard.dart';
import 'package:signtalk/components/solar_system_amination.dart';
import 'package:signtalk/navigation%20pages/user_mode.dart';
import 'package:signtalk/utils/constants.dart';
import 'package:lottie/lottie.dart';
import 'package:signtalk/utils/page_transition_direction.dart';
import 'package:signtalk/utils/slide_page_route.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(),
      endDrawer: const AppSideDrawer(),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;

          return Scaffold(
            backgroundColor: Colors.white,
            body:
                isMobile
                    ? _buildMobileLayout(context)
                    : _buildDesktopLayout(context),
          );
        },
      ),
    );
  }
}

Widget _buildMobileLayout(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      children: [
        // Smaller Lottie animation
        Lottie.asset('assets/lotties/Conversation.json', height: 180),

        const SizedBox(height: 20),

        // Headings centered for small screens
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Hands Speak",
                style: FontsConstant.headingMedium.copyWith(fontSize: 20),
              ),
              Text(
                "Bridge Gaps",
                style: FontsConstant.headingMedium.copyWith(
                  fontSize: 20,
                  color: ColorsConstant.extra,
                ),
              ),

              Text(
                "Care Flows",
                style: FontsConstant.headingMedium.copyWith(
                  fontSize: 20,
                  color: ColorsConstant.primary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            textAlign: TextAlign.center,
            "Bridging communication gaps between doctors and hearing/speech-impaired patients for inclusive healthcare in Ghana.",
            style: FontsConstant.headingMedium.copyWith(
              fontSize: 12,
              color: ColorsConstant.extra,
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Cards stacked vertically
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              InfoCard(
                onPressed: () => Navigator.pushNamed(context, '/healthWorker'),
                title: "Health Worker",
                subtitle:
                    "Use SignTalk to communicate with hearing/speech-impaired patients.",
                buttonName: "Let's Talk",
                isMobile: true,
              ),
              const SizedBox(height: 20),
              InfoCard(
                onPressed:
                    () => Navigator.pushNamed(context, '/hospitalListing'),
                title: "Patient",
                subtitle:
                    "Find the nearest hospital that uses SignTalk for sign language interpretation.",
                buttonName: "Find Hospital",
                isMobile: true,
              ),
              const SizedBox(height: 20),
              InfoCard(
                onPressed: () => Navigator.pushNamed(context, '/demoPage'),
                title: "Education",
                subtitle: "Learn with SignTalk, anytime, anywhere.",
                buttonName: "Start Learning",
                isMobile: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
      ],
    ),
  );
}

Widget _buildDesktopLayout(BuildContext context) {
  return CustomScrollView(
    slivers: [
      SliverFillRemaining(
        child: Stack(
          children: [
            // Background Lottie
            Positioned.fill(
              child: Image.asset(
                'assets/images/background3.jpg',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.3),
              ),
              // child: Lottie.asset(
              //   'assets/lotties/Conversation.json',
              //   fit: BoxFit.contain,
              // ),
            ),

            // Main content
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hands speak",
                                  style: FontsConstant.headingMedium.copyWith(
                                    fontSize: 52,
                                    color: ColorsConstant.darkPurple,
                                  ),
                                ),
                                Text(
                                  "gaps are bridged",
                                  style: FontsConstant.headingMedium.copyWith(
                                    fontSize: 52,
                                    color: ColorsConstant.darkPurple,
                                  ),
                                ),
                                Text(
                                  "care accessible to all!",
                                  style: FontsConstant.headingMedium.copyWith(
                                    fontSize: 52,
                                    color: ColorsConstant.darkPurple,
                                  ),
                                ),
                                Text(
                                  "Bridging communication gaps between doctors and hearing/speech-impaired patients for inclusive healthcare in Ghana.",
                                  style: FontsConstant.headingMedium.copyWith(
                                    color: ColorsConstant.secondary,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 80.0,
                                  ),
                                  child: GestureDetector(
                                    onTap:
                                        () => Navigator.push(
                                          context,
                                          SlidePageRoute(
                                            page: UserMode(),
                                            direction:
                                                PageTransitionDirection.right,
                                          ),
                                        ),
                                    child: exploreButton(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //Right panel cards
                Expanded(
                  flex: 4,
                  child: SolarSystemAnimation(),
                  // child: Container(
                  //   decoration: BoxDecoration(
                  //     color: ColorsConstant.extra.withOpacity(0.05),
                  //     image: DecorationImage(
                  //       image: AssetImage('assets/images/akwaaba.png'),
                  //       fit: BoxFit.cover,
                  //       opacity: 0.9,
                  //     ),
                  //     borderRadius: const BorderRadius.only(
                  //       topLeft: Radius.circular(20),
                  //       bottomLeft: Radius.circular(20),
                  //     ),
                  //   ),
                  // ),
                ),

                // // Right panel cards
                // Expanded(
                //   flex: 1,
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 20, right: 20),
                //     child: Column(
                //       children: [
                //         InfoCard(
                //           onPressed:
                //               () =>
                //                   Navigator.pushNamed(context, '/healthWorker'),
                //           title: "Health Worker",
                //           subtitle:
                //               "Use SignTalk to communicate with hearing/speech-impaired patients.",
                //           buttonName: "Let's Talk",
                //         ),
                //         const SizedBox(height: 20),
                //         InfoCard(
                //           onPressed: () {},
                //           // Navigator.pushNamed(context, '/hospitalListing'),
                //           title: "Patient",
                //           subtitle:
                //               "Find the nearest hospital that uses SignTalk for sign language interpretation.",
                //           buttonName: "Find Hospital",
                //         ),
                //         const SizedBox(height: 20),
                //         InfoCard(
                //           // onPressed: () {},
                //           onPressed:
                //               () => Navigator.pushNamed(context, '/demoPage'),
                //           title: "Education",
                //           subtitle: "Learn with SignTalk, anytime, anywhere.",
                //           buttonName: "Start Learning",
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
