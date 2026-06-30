import 'package:flutter/cupertino.dart';

import '../../../../core/utils/app_colors.dart';

Widget leaderItem({
  required String images,
  required String name,
  required String image,
}) {
  return Column(
    children: [
      Row(
        children: [
          Image.asset(
            images,
            height: 45,
            width: 45,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.secondary,
              ),
            ),
          ),
          Image.asset(
            image,
            height: 45,
            width: 45,
          ),
        ],
      ),
      const SizedBox(height: 10),
      Container(
        width: double.infinity,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xff9BC16C),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ],
  );
}
