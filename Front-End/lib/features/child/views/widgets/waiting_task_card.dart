import 'package:flutter/material.dart';
import 'package:yallado/core/utils/app_colors.dart';

class WaitingTaskCard extends StatelessWidget {
  final String title;
  final int progress;

  const WaitingTaskCard({
    super.key,
    required this.title,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 5,
            offset:  Offset(0, 6),
          )
        ]
      ),
      child: Row(
        children: [
          Image.asset('images/preview3.png', height: 80, width: 80),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style:  TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColor.secondary,
                            ),
                          ),
                           SizedBox(height: 8),
                        ],
                      ),
                    ),
                     Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
                 SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 30),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress / 10,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            color: Color(0xFFFCCE1D),
                            minHeight: 10,
                          ),
                        ),
                      ),
                    ),
                     SizedBox(width: 5),
                    Text(
                      '$progress/10',
                      style:  TextStyle(
                        color: AppColor.secondary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
