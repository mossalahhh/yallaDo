import 'package:flutter/material.dart';
import 'package:yallado/core/utils/app_colors.dart';
class AvatarItem extends StatelessWidget {
  final String image;
  final bool isActive;
  final bool locked;

  const AvatarItem({
    required this.image,
    required this.isActive,
    required this.locked,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isActive ? 1.5 : 0.8,
      duration:  Duration(milliseconds: 300),
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 32),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            alignment: Alignment.center,
            children: [
              image.startsWith('http')
                  ? Image.network(
                      image,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, size: 80),
                    )
                  : Image.asset(
                      image,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
              if (locked)
                const Icon(Icons.lock, color: Colors.white70, size: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class AvatarArrow extends StatelessWidget {
  final bool isLeft;
  final VoidCallback onTap;
  final bool enabled;

  const AvatarArrow({
    super.key,
    required this.isLeft,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Icon(
        isLeft ? Icons.arrow_left_rounded : Icons.arrow_right_rounded,
        size: 120,
        color: AppColor.secondary,
      ),
    );
  }
}