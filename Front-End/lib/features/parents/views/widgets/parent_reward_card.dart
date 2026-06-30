import 'package:flutter/material.dart';
import 'package:yallado/core/widgets/app_network_image.dart';

class ParentRewardCard extends StatelessWidget {
  final String title;
  final int points;
  final String image;
  final Color color;
  final bool isActive;
  final VoidCallback? onTap;

  const ParentRewardCard({
    super.key,
    required this.title,
    required this.points,
    required this.image,
    required this.color,
    this.isActive = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isActive ? 1 : 0.5,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color, width: 2),
                gradient: LinearGradient(
                  colors: [color, const Color(0xfffdfdfd)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: image.startsWith('http')
                        ? AppNetworkImage(image, fit: BoxFit.contain)
                        : Image.asset(image, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 8),
                  Text(title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xff225277))),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$points',
                          style: const TextStyle(
                              color: Color(0xff225277),
                              fontWeight: FontWeight.bold)),
                      Image.asset("images/coins2.png", width: 20, height: 20),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const Positioned(
              top: 4,
              right: 4,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white,
                child: Icon(Icons.more_horiz,
                    size: 18, color: Color(0xff225277)),
              ),
            ),
            if (!isActive)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text("Inactive",
                      style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
