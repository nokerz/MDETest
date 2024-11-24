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
      leadingWidth: 72,
      leading: Container(
        padding: const EdgeInsets.only(left: 16),
        child: IconButton(
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 107, 131, 1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: 16,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 107, 131, 1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: 24,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 107, 131, 1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          onPressed: () {
            // Add drawer functionality here
          },
        ),
      ),
      title: Center(
        child: Image.asset(
          'assets/images/logo.jpg',
          height: 100,
        ),
      ),
    );
  }
}
