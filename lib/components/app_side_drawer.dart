import 'package:flutter/material.dart';
import 'package:signtalk/utils/constants.dart';

class AppSideDrawer extends StatelessWidget {
  const AppSideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Menu", style: FontsConstant.headingLarge),
              const SizedBox(height: 20),

              _drawerItem(context, "Overview", '/overview'),
              _drawerItem(context, "Technology", '/technology'),
              _drawerItem(context, "Use Cases", '/useCases'),

              const Spacer(),

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsConstant.tertiary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "HELP US GROW",
                  style: TextStyle(color: Colors.black),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String title, String route) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: FontsConstant.bodyMedium),
      onTap: () {
        Navigator.pop(context); // close drawer
        Navigator.pushNamed(context, route);
      },
    );
  }
}
