import 'package:flutter/material.dart';
import 'package:signtalk/components/customAppBar.dart';
import 'package:signtalk/components/exploreButton.dart';
import 'package:signtalk/components/infoCard.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),

      body: CustomScrollView(
        slivers: [
          // ===== MAIN CONTENT WITH BACKGROUND IMAGE =====
          SliverFillRemaining(
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/signtalk_girl.jpg",
                    fit: BoxFit.cover, // fills entire background
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
                                    const Text(
                                      "HANDS SPEAK",
                                      style: TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        height: 1.2,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 100.0,
                                      ),
                                      child: Row(
                                        children: const [
                                          Text(
                                            "GAPS ",
                                            style: TextStyle(
                                              fontSize: 42,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              height: 1.2,
                                            ),
                                          ),
                                          Text(
                                            "CLOSE",
                                            style: TextStyle(
                                              fontSize: 42,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.brown,
                                              height: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Text(
                                      "CARE FLOWS",
                                      style: TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        height: 1.2,
                                      ),
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
                                  const Text(
                                    "Bridging communication gaps between \ndoctors and hearing/speech-impaired patients \nfor inclusive healthcare in Ghana.",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black54,
                                    ),
                                  ),

                                  exploreButton(),

                                  // ElevatedButton.icon(
                                  //   onPressed: () {},
                                  //   style: ElevatedButton.styleFrom(
                                  //     backgroundColor: Colors.lightBlueAccent,
                                  //     padding: const EdgeInsets.symmetric(
                                  //       horizontal: 24,
                                  //       vertical: 16,
                                  //     ),
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(30),
                                  //     ),
                                  //   ),
                                  //   icon: const Icon(Icons.play_arrow),
                                  //   label: const Text("Explore Your Mind"),
                                  // ),
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
                              title: "Patient",
                              subtitle:
                                  "Find the nearest hospital that uses SignTalk for sign language interpretation.",
                              buttonName: "Find Hospital",
                            ),
                            const SizedBox(height: 20),
                            InfoCard(
                              title: "Education",
                              subtitle:
                                  "Learn with SignTalk, anytime, anywhere.",
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
      ),
    );
  }
}
