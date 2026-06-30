import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../readmore_details.dart';

class KidCard extends StatelessWidget {
  final String childId;
  final String name;
  final String age;
  final String avatarUrl;
  final int totalPoints;

  const KidCard({
    super.key,
    required this.childId,
    required this.name,
    required this.age,
    required this.avatarUrl,
    required this.totalPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xffe4ead4)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppAvatar(url: avatarUrl, radius: 27),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name: $name",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColor.secondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Age: $age years",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColor.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Row(
                children: [
                  Text(
                    "Score: $totalPoints",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColor.secondary,
                    ),
                  ),
                  Image.asset("images/star.png", height: 20, width: 20),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MoreDetailsScreen(
                        childId: childId,
                        name: name,
                        avatarUrl: avatarUrl,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Read more",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
