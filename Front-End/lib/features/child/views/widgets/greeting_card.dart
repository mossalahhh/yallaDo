import 'package:flutter/material.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/features/user/data/models/user_model.dart';
import 'package:yallado/features/user/profile_store.dart';

class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.secondary,
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Personalised greeting that reflects a name change live.
                    Flexible(
                      child: ValueListenableBuilder<UserProfile?>(
                        valueListenable: ProfileStore.profile,
                        builder: (context, profile, _) {
                          final name = profile?.user.name;
                          final who =
                              (name != null && name.isNotEmpty) ? name : 'Champ';
                          return Text(
                            'Hey $who! 🏆',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFF06804),
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    Image.asset("images/child.png", height: 112, width: 111),
                  ],
                ),
                const Text(
                  'Ready for today’s challenges?\nLet’s earn more points and have fun!',
                  style: TextStyle(
                      color: AppColor.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
