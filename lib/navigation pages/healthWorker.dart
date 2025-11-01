import 'package:flutter/material.dart';
import 'package:signtalk/components/customAppBar.dart';
import 'package:signtalk/components/themeCard.dart';
import 'package:signtalk/utils/constants.dart';

class Department {
  final String image;
  final String title;
  final String description;
  final String category;

  Department({
    required this.image,
    required this.title,
    required this.description,
    required this.category,
  });
}

class Healthworker extends StatelessWidget {
  Healthworker({super.key});

  final List<Department> departments = [
    Department(
      image: "assets/images/OPD.jpg",
      title: "OPD Visit",
      description:
          "Outpatient Department visits provide first-level consultations, basic diagnosis, and treatments without admission.",
      category: "opd",
    ),
    Department(
      image: "assets/images/ANC.jpg",
      title: "Maternity Care & ANC",
      description:
          "Antenatal and maternity care services ensure safe pregnancy, childbirth, and postnatal support for mothers and babies.",
      category: "maternity",
    ),
    Department(
      image: "assets/images/pharmacy.jpg",
      title: "Pharmacy",
      description:
          "The pharmacy provides prescribed medications, health advice, and guidance on safe drug use.",
      category: "pharmacy",
    ),
    Department(
      image: "assets/images/radiology.jpg",
      title: "Radiology",
      description:
          "Radiology offers imaging services like X-rays and ultrasounds for accurate diagnosis and treatment planning.",
      category: "radiology",
    ),
    Department(
      image: "assets/images/child_welfare.jpg",
      title: "Child Welfare Clinic",
      description:
          "This clinic focuses on child immunization, growth monitoring, and nutrition education for parents.",
      category: "child_welfare",
    ),
    Department(
      image: "assets/images/laboratory.jpg",
      title: "Laboratory",
      description:
          "The laboratory conducts diagnostic tests and screenings to assist doctors in effective medical evaluation.",
      category: "laboratory",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Breakpoints
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1000;
    final bool isDesktop = width >= 1000;

    // Number of columns for each device
    int crossAxisCount = 1;
    if (isTablet) crossAxisCount = 2;
    if (isDesktop) crossAxisCount = 3;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 60 : isTablet ? 32 : 16,
          vertical: 20,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Header
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
              "Getting medical help should be easy and accessible for everyone.\n"
              "Choose the department and get started.",
              textAlign: TextAlign.center,
              style: FontsConstant.headingMedium.copyWith(
                fontSize: isMobile ? 14 : 18,
                color: ColorsConstant.textColor,
              ),
            ),

            const SizedBox(height: 40),

            // ✅ Responsive Grid for Department Cards
            LayoutBuilder(
              builder: (context, constraints) {
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: departments.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio:
                        isMobile ? 0.9 : isTablet ? 1.1 : 1.3,
                  ),
                  itemBuilder: (context, index) {
                    final dept = departments[index];
                    return ThemeCard(
                      image: dept.image,
                      title: dept.title,
                      description: dept.description,
                      category: dept.category,
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
