import 'package:flutter/material.dart';
import 'package:signtalk/components/customAppBar.dart';
import 'package:signtalk/components/exploreButton.dart';
import 'package:signtalk/components/infoCard.dart';
import 'package:signtalk/utils/constants.dart';
import 'package:lottie/lottie.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ===== MAIN CONTENT WITH BACKGROUND IMAGE =====
          SliverFillRemaining(
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Lottie.asset(
                    'assets/lotties/Conversation.json',
                    height: 200,
                  ),
                ),

                // Foreground Content
                Row(
                  children: [
                    // ===== LEFT CONTENT =====
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          // vertical: 30,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ===== CENTERED HEADINGS =====
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hands Speak",
                                      style: FontsConstant.headingMedium
                                          .copyWith(fontSize: 42),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 100.0,
                                      ),
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
                                                  color: ColorsConstant.primary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "Care Flows",
                                      style: FontsConstant.headingMedium
                                          .copyWith(fontSize: 42),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // ===== BOTTOM TEXT + BUTTON =====
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Bridging communication gaps between \ndoctors and hearing/speech-impaired patients \nfor inclusive healthcare in Ghana.",
                                    style: FontsConstant.headingMedium.copyWith(
                                      color: ColorsConstant.extra,
                                    ),
                                  ),

                                  //  exploreButton(),
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
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
