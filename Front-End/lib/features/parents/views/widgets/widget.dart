import 'package:flutter/material.dart';
import 'package:yallado/core/utils/app_colors.dart';

class RewardCard extends StatelessWidget {
  final String title;
  final Color bottomColor;
  final VoidCallback? onTap;

  const RewardCard({
    super.key,
    required this.title,
    this.bottomColor = const Color(0xffb6e99a),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 115,
        height: 160,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 6),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, bottomColor],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColor.primary,
          ),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                const SizedBox(width: double.infinity, height: 20),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Image.asset("images/coins2.png", width: 20, height: 20),
                ),
                Positioned(
                  top: 0,
                  right: 10,
                  child: Image.asset("images/coins2.png", width: 20, height: 20),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Image.asset("images/coins2.png", width: 20, height: 20),
                ),
              ],
            ),
            Image.asset(
              "images/playstation.png",
              height: 80,
              width: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: AppColor.secondary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Widget customField() {
  return TextFormField(
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Color(0xFF8B7F74), width: 3),
      ),
    ),
  );
}

Widget avatar(String imagePath) {
  return CircleAvatar(
    radius: 35,
    backgroundColor: const Color(0xffD7EBC7),
    child: ClipOval(
      child: Image.asset(
        imagePath,
        width: 50,
        height: 60,
        fit: BoxFit.cover,
      ),
    ),
  );
}

class AvatarItem extends StatelessWidget {
  final String name;
  final String imagePath;

  const AvatarItem({
    super.key,
    required this.name,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: const Color(0xffD7EBC7),
          child: ClipOval(
            child: Image.asset(
              imagePath,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: AppColor.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const CategoryItem({
    super.key,
    required this.title,
    this.icon = Icons.category,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColor.primary,
          child: Icon(
            icon,
            color: AppColor.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColor.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}