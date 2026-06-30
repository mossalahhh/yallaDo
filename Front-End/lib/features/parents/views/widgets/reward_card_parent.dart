
import 'package:flutter/material.dart';
import 'package:yallado/core/utils/app_colors.dart';

class RewardCardParent extends StatelessWidget {
  final String title;
  final int points;
  final String image;
  final Color color;
  final VoidCallback? onAdd;

  const RewardCardParent({
    super.key,
    required this.title,
    required this.points,
    required this.image,
    required this.color,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color, width: 2),
            gradient: LinearGradient(
              colors: [color, Color(0xfffdfdfd)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Image.asset(image, width: 90, height: 90, fit: BoxFit.contain),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xff225277),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$points',
                    style: const TextStyle(
                      color: Color(0xff225277),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset("images/coins2.png", width: 20, height: 20),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),

        Positioned(
          top: 4,
          right: 4,
          child: IconButton(
            onPressed: (){},
            icon: const Icon(
              Icons.add,
              size: 18,
              color: Color(0xff225277),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}