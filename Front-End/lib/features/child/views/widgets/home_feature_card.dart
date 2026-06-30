import 'package:flutter/material.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/features/ai/views/chat_view.dart';
import 'package:yallado/features/child/views/child_avatar_view.dart';
import 'package:yallado/features/child/views/child_tasks_view.dart';
import 'package:yallado/features/child/views/leaderboard_view.dart';
import 'package:yallado/features/child/views/child_rewards_view.dart';

class HomeFeatureCard extends StatelessWidget {
  final String title;
  final String image;
  final Color color;

  const HomeFeatureCard({
    super.key,
    required this.title,
    required this.image,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          if (title == 'My Challenge') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChildTasksView()),
            );
          } else if (title == 'Leader Board') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LeaderBoardScreen()),
            );
          } else if (title == 'My Reward') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChildRewardsView()),
            );
          } else if (title == 'My Chat') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatView()),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color,
              width: 2,
            ),
            gradient: LinearGradient(
              colors: [
                color,
                Color(0xfffdfdfd),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Image.asset(image, fit: BoxFit.contain),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColor.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
