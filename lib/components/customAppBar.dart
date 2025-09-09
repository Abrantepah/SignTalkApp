import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      toolbarHeight: 60,
      automaticallyImplyLeading: false,
      title: InkWell(
        onTap: () => Navigator.pushNamed(context, '/'),
        child: Row(
          children: const [
            Icon(Icons.blur_circular, color: Colors.blue),
            SizedBox(width: 10),
            Text(
              "SIGNTALK",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/overview'),
          child: Text("Overview", style: TextStyle(color: Colors.black)),
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/technology'),
          child: Text("Technology", style: TextStyle(color: Colors.black)),
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/useCases'),
          child: Text("Use Cases", style: TextStyle(color: Colors.black)),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            "HELP US GROW",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  // ✅ Required to use AppBar as PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(60);
}
