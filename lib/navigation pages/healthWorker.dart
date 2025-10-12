import 'package:flutter/material.dart';
import 'package:signtalk/components/customAppBar.dart';
import 'package:signtalk/components/ThemeCard.dart';
import 'package:signtalk/utils/constants.dart';

class Department {
  final String image;
  final String title;
  final String description;

  Department({
    required this.image,
    required this.title,
    required this.description,
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
    ),
    Department(
      image: "assets/images/ANC.jpg",
      title: "Maternity Care & ANC",
      description:
          "Antenatal and maternity care services ensure safe pregnancy, childbirth, and postnatal support for mothers and babies.",
    ),
    Department(
      image: "assets/images/pharmacy.jpg",
      title: "Pharmacy",
      description:
          "The pharmacy provides prescribed medications, health advice, and guidance on safe drug use.",
    ),
    Department(
      image: "assets/images/radiology.jpg",
      title: "Radiology",
      description:
          "Radiology offers imaging services like X-rays and ultrasounds for accurate diagnosis and treatment planning.",
    ),
    Department(
      image: "assets/images/child_welfare.jpg",
      title: "Child Welfare Clinic",
      description:
          "This clinic focuses on child immunization, growth monitoring, and nutrition education for parents.",
    ),
    Department(
      image: "assets/images/laboratory.jpg",
      title: "Laboratory",
      description:
          "The laboratory conducts diagnostic tests and screenings to assist doctors in effective medical evaluation.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 12),
              child: Text(
                "SignTalk for Health Workers",
                style: FontsConstant.headingLarge.copyWith(
                  fontSize: 35,
                  color: ColorsConstant.textColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Getting medical help should be easy and accessible for everyone.\n"
                "Choose the department and get started.",
                textAlign: TextAlign.center,
                style: FontsConstant.headingMedium.copyWith(
                  color: ColorsConstant.textColor,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Department Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  for (int i = 0; i < departments.length; i += 3)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          (i + 3 <= departments.length)
                              ? 3
                              : departments.length - i,
                          (index) {
                            final dept = departments[i + index];
                            return ThemeCard(
                              image: dept.image,
                              title: dept.title,
                              description: dept.description,
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
