// lib/widgets/custom_header.dart
import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  const CustomHeader({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          color: Colors.black,
          size: 28,
        ),
        onPressed: () {
          // Add drawer functionality here
        },
      ),
      title: Center(
        child: Image.asset(
          'assets/images/logo.jpg', // logo
          height: 100,
        ),
      ),
    );
  }
}
