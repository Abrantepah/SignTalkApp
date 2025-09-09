import 'package:flutter/material.dart';
import 'package:signtalk/components/customAppBar.dart';
import 'package:signtalk/components/themeCard.dart';
import 'package:signtalk/navigation%20pages/home.dart';

class Healthworker extends StatefulWidget {
  const Healthworker({super.key});

  @override
  State<Healthworker> createState() => _HealthworkerState();
}

class _HealthworkerState extends State<Healthworker> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [Home(), Placeholder(), Placeholder()];

  // Example image data with titles & button names
  final List<Map<String, String>> _cards = [
    {
      "title": "Doctor",
      "assetImage": "assets/images/doctor.png",
      "buttonName": "Talk",
    },
    {
      "title": "Nurse",
      "assetImage": "assets/images/nurse.png",
      "buttonName": "Meet",
    },
    {
      "title": "Hospital",
      "assetImage": "assets/images/hospital.png",
      "buttonName": "Find",
    },
    {
      "title": "Lab",
      "assetImage": "assets/images/lab.png",
      "buttonName": "Test",
    },
    {
      "title": "Pharmacy",
      "assetImage": "assets/images/pharmacy.png",
      "buttonName": "Buy",
    },
    {
      "title": "Ambulance",
      "assetImage": "assets/images/ambulance.png",
      "buttonName": "Call",
    },
  ];

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: CustomScrollView(
        slivers: [
          // ===== Grid of Smaller Simple Cards =====
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final card = _cards[index];
                return ThemeCard(
                  title: card["title"]!,
                  assetImage: card["assetImage"]!,
                  buttonName: card["buttonName"]!,
                  onPressed: () {
                    print("${card["title"]} tapped");
                  },
                );
              }, childCount: _cards.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 per row
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.9, // smaller & balanced
              ),
            ),
          ),

          // ===== Main Page Content =====
          SliverToBoxAdapter(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}
