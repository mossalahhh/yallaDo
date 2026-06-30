import 'package:flutter/material.dart';
import 'package:yallado/core/utils/app_colors.dart';

class GreetingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:  EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.secondary,
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            AppColor.primary,
            AppColor.primary,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text(
                    'Hey Champ! 🏆',
                    style: TextStyle(
                      color:  Color(0xFFF06804),
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset("images/child.png",height: 112,width: 111,),
                ],),
                Text(
                  'Ready for today’s challenges?\nLet’s earn more points and have fun!',
                  style: TextStyle(
                    color:  AppColor.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
