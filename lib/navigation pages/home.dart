import 'package:flutter/material.dart';
import 'package:signtalk/components/app_side_drawer.dart';
import 'package:signtalk/components/customAppBar.dart';
import 'package:signtalk/components/infoCard.dart';
import 'package:signtalk/utils/constants.dart';
import 'package:lottie/lottie.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Lottie.asset(
                'assets/lotties/Conversation.json',
                fit: BoxFit.contain,
              ),
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
                                  "Hands Speak",
                                  style: FontsConstant.headingMedium.copyWith(
                                    fontSize: 42,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 100),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Bridge ",
                                        style: FontsConstant.headingMedium
                                            .copyWith(fontSize: 42),
                                      ),
                                      Text(
                                        "Gaps",
                                        style: FontsConstant.headingMedium
                                            .copyWith(
                                              fontSize: 42,
                                              color: ColorsConstant.extra,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "Care Flows",
                                  style: FontsConstant.headingMedium.copyWith(
                                    fontSize: 42,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Bridging communication gaps between \ndoctors and hearing/speech-impaired patients \nfor inclusive healthcare in Ghana.",
                                style: FontsConstant.headingMedium.copyWith(
                                  color: ColorsConstant.extra,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                    // ===== RIGHT CARDS =====
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, right: 20),
                        child: Column(
                          children: [
                            InfoCard(
                              onPressed: () {
                                Navigator.pushNamed(context, '/healthWorker');
                              },
                              title: "Health Worker",
                              subtitle:
                                  "Use SignTalk to communicate with hearing/speech-impaired patients.",
                              buttonName: "Lets Talk",
                            ),
                            const SizedBox(height: 20),
                            InfoCard(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/hospitalListing',
                                );
                              },
                              title: "Patient",
                              subtitle:
                                  "Find the nearest hospital that uses SignTalk for sign language interpretation.",
                              buttonName: "Find Hospital",
                            ),
                            const SizedBox(height: 20),
                            InfoCard(
                              onPressed: () {
                                Navigator.pushNamed(context, '/demoPage');
                              },
                              title: "What is SignTalk?",
                              subtitle:
                                  "Learn more about SignTalk and how it works.",
                              buttonName: "Watch A Demo",
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        InfoCard(
                          onPressed: () {},
                          // Navigator.pushNamed(context, '/hospitalListing'),
                          title: "Patient",
                          subtitle:
                              "Find the nearest hospital that uses SignTalk for sign language interpretation.",
                          buttonName: "Find Hospital",
                        ),
                        const SizedBox(height: 20),
                        InfoCard(
                          onPressed: () {},
                          // onPressed: () =>
                          //     Navigator.pushNamed(context, '/demoPage'),
                          title: "Education",
                          subtitle: "Learn with SignTalk, anytime, anywhere.",
                          buttonName: "Start Learning",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
