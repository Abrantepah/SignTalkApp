import 'package:flutter/material.dart';
import 'package:signtalk/utils/constants.dart';
import 'package:signtalk/components/app_side_drawer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 800; // ✅ breakpoint

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: ColorsConstant.tertiary.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: 60,

        title: _buildLogo(context),

        // ✅ Mobile shows menu icon ➜ opens drawer
        // ✅ Desktop shows full menu
        actions: isMobile
            ? _buildMobileMenu(context)
            : _buildDesktopMenu(context),
      ),
    );
  }

  // ✅ Logo (same for mobile + desktop)
  Widget _buildLogo(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/'),
      child: Row(
        children: [
          Image.asset(
            "assets/images/signtalklogo.png",
            height: 50,
            width: 50,
          ),
          const SizedBox(width: 5),
          Text(
            "SignTalk",
            style: FontsConstant.headingMedium.copyWith(
              color: ColorsConstant.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Desktop menu bar
  List<Widget> _buildDesktopMenu(BuildContext context) {
    return [
      TextButton(
        onPressed: () => Navigator.pushNamed(context, '/'),
        child: Text("Home", style: FontsConstant.bodyMedium),
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
    ];
  }

  // ✅ Mobile only → menu icon that opens drawer
  List<Widget> _buildMobileMenu(BuildContext context) {
    return [
      Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            Scaffold.of(context).openEndDrawer(); 
            // ✅ Drawer opens from right (use openDrawer() for left)
          },
        ),
      ),
    ];
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
