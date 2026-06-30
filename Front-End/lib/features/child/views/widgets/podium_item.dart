import 'package:flutter/material.dart';

Widget podium3D({
  required String rank,
  required double height,
  bool isFirst = false,
  Image? image,
}) {
   double depth = 15;
   double width = 100;

  final frontColor =
  isFirst ?  Color(0xffD6CCFF) :  Color(0xffEEEAFE);
  final sideColor =
  isFirst ?  Color(0xff988adc) :  Color(0xffD5CFFF);
  final topColor =
  isFirst ?  Color(0xffF2EDFF) :  Color(0xffFAF8FF);

  return SizedBox(
    width: width + depth,
    height: height + depth,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: 0,
          bottom: depth,
          child: Container(
            width: depth,
            height: height,
            decoration: BoxDecoration(
              color: sideColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
        ),

        Positioned(
          top: 0,
          left: depth,
          child: Transform(
            transform: Matrix4.skewX(-0.60),
            child: Container(
              width: width,
              height: depth,
              decoration: BoxDecoration(
                color: topColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
            ),
          ),
        ),

        Positioned(
          left: 0,
          bottom: 0,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: frontColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 14,
                  offset:  Offset(6, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isFirst && image != null)
                  Container(
                    margin:  EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset:  Offset(0, 4),
                        ),
                      ],
                    ),
                    child: image,
                  ),

                Text(
                  rank,
                  style:  TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                 SizedBox(height: 4),
                Container(
                  width: 30,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
Widget podiumSection() {
  return SizedBox(
    height: 300,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
             Text(" "),
             SizedBox(height: 6),
            podium3D(rank: "3", height: 120),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
             Text(
              " ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 6),
            podium3D(
              rank: "1",
              height: 210,
              isFirst: true,
              image: Image.asset(
                "images/hero.png",
                width: 70,
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
             Text(" "),
             SizedBox(height: 6),
            podium3D(rank: "2", height: 165),
          ],
        ),
      ],
    ),
  );
}
