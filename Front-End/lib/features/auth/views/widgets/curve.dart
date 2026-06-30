import 'package:flutter/material.dart';

class CurvedHeader extends StatelessWidget {
  final double height;

  const CurvedHeader({super.key, this.height = 330});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        height: height,
        width: double.infinity,
        color: const Color(0xFFD8E4CC),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // top left
    path.lineTo(0, size.height * 0.28);

    path.cubicTo(
      0,
      size.height * 0.75,
      size.width * 0.28,
      size.height * 0.88,
      size.width * 0.47,
      size.height * 0.72,
    );

    path.cubicTo(
      size.width * 0.68,
      size.height * 0.55,
      size.width * 0.82,
      size.height * 0.72,
      size.width * 0.92,
      size.height * 0.92,
    );

    path.cubicTo(
      size.width * 0.96,
      size.height,
      size.width * 0.985,
      size.height * 1.02,
      size.width,
      size.height * 0.96,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
class CurvedHeaderTwo extends StatelessWidget {
  final double height;

  const CurvedHeaderTwo({super.key, this.height = 340});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HeaderClipperTwo(),
      child: Container(
        height: height,
        width: double.infinity,
        color: const Color(0xFFD9E5CE),
      ),
    );
  }
}

class HeaderClipperTwo extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height * 0.82);

    path.cubicTo(
      size.width * 0.12,
      size.height * 0.48,

      size.width * 0.38,
      size.height * 0.38,

      size.width * 0.52,
      size.height * 0.58,
    );

    path.cubicTo(
      size.width * 0.70,
      size.height * 0.90,

      size.width * 0.88,
      size.height * 0.92,

      size.width,
      size.height * 0.78,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }


  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
  }

class TopCurveHeader extends StatelessWidget {
  const TopCurveHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipPath(
            clipper: TopCurveClipper(),
            child: Container(
              height: 260,
              width: double.infinity,
              color: Color(0xFFD8E4CC),
            ),
          ),

          Positioned(
           top: 100,
            left: 150,
            child: Center(
              child: Image.asset(
                "images/preview2.png",
                height: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    double startY = size.height - 80;
    double dipY   = size.height - 140;

    path.lineTo(0, startY);

    path.cubicTo(
      size.width * 0.25, startY,
      size.width * 0.35, dipY,
      size.width * 0.5, dipY,
    );

    path.cubicTo(
      size.width * 0.65, dipY,
      size.width * 0.75, startY,
      size.width, startY,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}