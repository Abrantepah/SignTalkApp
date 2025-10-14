import 'package:flutter/material.dart';
import 'package:signtalk/utils/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: ColorsConstant.tertiary.withOpacity(
              0.4,
            ), // 👈 soft blue glow
            blurRadius: 20, // makes it soft
            spreadRadius: 5, // spreads the shadow outward
            offset: const Offset(0, 5), // pushes shadow slightly down
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent, // removes M3 tint
        elevation: 0, // we’re using custom shadow now
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () => Navigator.pushNamed(context, '/'),
          child: Row(
            children: [
              Image.asset(
                "assets/images/signtalklogo.png",
                height: 70,
                width: 70,
              ),
              const SizedBox(width: 10),
              Text(
                "SignTalk",
                style: FontsConstant.headingLarge.copyWith(
                  color: ColorsConstant.primary,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/overview'),
            child: Text("Overview", style: FontsConstant.bodyMedium),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/technology'),
            child: Text("Technology", style: FontsConstant.bodyMedium),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/useCases'),
            child: Text("Use Cases", style: FontsConstant.bodyMedium),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsConstant.tertiary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "HELP US GROW",
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
