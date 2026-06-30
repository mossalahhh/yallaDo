import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/core/widgets/app_error_retry.dart';
import 'package:yallado/core/widgets/app_network_image.dart';
import 'package:yallado/features/child/cubit/leaderboard_cubit/leaderboard_cubit.dart';
import 'package:yallado/features/child/data/models/leader_model.dart';

class LeaderBoardScreen extends StatelessWidget {
  const LeaderBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LeaderboardCubit()..load(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColor.primary, AppColor.white],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: BlocBuilder<LeaderboardCubit, LeaderboardState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios,
                                color: AppColor.secondary),
                          ),
                          const Expanded(
                            child: Text(
                              "Let's See Who is The Hero 🏆✨",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.secondary),
                            ),
                          ),
                        ],
                      ),
                      if (state is LeaderboardLoading)
                        const Expanded(
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: AppColor.secondary)),
                        )
                      else if (state is LeaderboardError)
                        Expanded(
                          child: AppErrorRetry(
                            message: state.message,
                            onRetry: () =>
                                context.read<LeaderboardCubit>().load(),
                          ),
                        )
                      else if (state is LeaderboardLoaded)
                        Expanded(child: _content(state))
                      else
                        const SizedBox.shrink(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(LeaderboardLoaded state) {
    final top = state.top3;
    if (top.isEmpty) {
      return const Center(
          child: Text("No rankings yet",
              style: TextStyle(color: AppColor.secondary, fontSize: 16)));
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("Your Rank:  #${state.myRank}",
                style: const TextStyle(
                    color: AppColor.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
          const SizedBox(height: 24),
          // Podium: 2nd | 1st | 3rd
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (top.length > 1) _podium(top[1], 2, 130),
              if (top.isNotEmpty) _podium(top[0], 1, 170),
              if (top.length > 2) _podium(top[2], 3, 110),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xfff9f7f0),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              children: List.generate(top.length, (i) {
                final l = top[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Text("#${i + 1}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColor.secondary)),
                      const SizedBox(width: 12),
                      AppAvatar(url: l.avatarUrl, radius: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(l.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColor.secondary)),
                      ),
                      Text("${l.points} ⭐",
                          style: const TextStyle(color: AppColor.secondary)),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _podium(LeaderModel leader, int place, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (place == 1)
            const Icon(Icons.emoji_events, color: Color(0xffF6B100), size: 36),
          AppAvatar(url: leader.avatarUrl, radius: place == 1 ? 36 : 30),
          const SizedBox(height: 6),
          Text(leader.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppColor.secondary, fontWeight: FontWeight.bold)),
          Text("${leader.points} ⭐",
              style: const TextStyle(color: AppColor.secondary, fontSize: 12)),
          const SizedBox(height: 4),
          Container(
            width: 80,
            height: height,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColor.primary, Colors.white],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border.all(color: AppColor.secondary),
            ),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 8),
            child: Text("$place",
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColor.secondary)),
          ),
        ],
      ),
    );
  }
}
