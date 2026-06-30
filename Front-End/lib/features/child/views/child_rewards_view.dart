import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/core/widgets/app_refresh.dart';
import 'package:yallado/features/child/views/widgets/animation.dart';
import 'package:yallado/features/child/views/widgets/reward_card.dart';
import 'package:yallado/features/rewards/cubit/child_rewards_cubit/child_rewards_cubit.dart';
import 'package:yallado/features/rewards/cubit/child_rewards_cubit/child_rewards_state.dart';
import 'package:yallado/features/rewards/data/models/reward_model.dart';

class ChildRewardsView extends StatelessWidget {
  const ChildRewardsView({super.key});

  static const _palette = [
    Color(0xffa6c7e2),
    Color(0xfffde798),
    Color(0xffbeeba7),
    Color(0xffFFAFCC),
  ];

  void _confirmRedeem(BuildContext context, RewardModel reward) {
    final cubit = context.read<ChildRewardsCubit>();
    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        backgroundColor: const Color(0xFFF9F7F0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Redeem Reward",
            style: TextStyle(
                color: AppColor.secondary, fontWeight: FontWeight.bold)),
        content: Text(
            "Redeem \"${reward.name}\" for ${reward.points} points?",
            style: const TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.secondary),
            onPressed: () {
              Navigator.pop(dctx);
              cubit.redeem(reward.id);
            },
            child: const Text("Redeem", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChildRewardsCubit()..load(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F7F0),
        body: BlocConsumer<ChildRewardsCubit, ChildRewardsState>(
          listener: (context, state) {
            if (state is RedeemSuccess) {
              SnackBarPopUp().show(
                  context: context,
                  message: state.message,
                  state: PopUpState.success);
            } else if (state is RedeemError || state is ChildRewardsError) {
              final msg = state is RedeemError
                  ? state.message
                  : (state as ChildRewardsError).message;
              SnackBarPopUp().show(
                  context: context, message: msg, state: PopUpState.error);
            }
          },
          builder: (context, state) {
            final cubit = context.read<ChildRewardsCubit>();
            final rewards = cubit.rewards;
            return AppRefresh(
              onRefresh: () => context.read<ChildRewardsCubit>().load(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                children: [
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_outlined,
                            color: Color(0xFF322B67)),
                      ),
                      const Spacer(),
                      Image.asset('images/TICKY.png', height: 30, width: 130),
                      Image.asset('images/log3.png', height: 80, width: 80),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Text('Awards 🏆',
                            style: TextStyle(
                                color: AppColor.secondary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text('${cubit.points} 💰',
                            style: const TextStyle(
                                color: AppColor.secondary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (state is ChildRewardsLoading && rewards.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(
                          color: AppColor.secondary),
                    )
                  else if (rewards.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(40),
                      child: Text("No rewards yet",
                          style: TextStyle(
                              color: AppColor.secondary, fontSize: 16)),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.95,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(rewards.length, (i) {
                          final r = rewards[i];
                          return AnimatedRewardItem(
                            index: i,
                            child: RewardCard(
                              title: r.name,
                              points: r.points,
                              image: r.imageUrl.isNotEmpty
                                  ? r.imageUrl
                                  : 'images/toy.png',
                              color: _palette[i % _palette.length],
                              onTap: () => _confirmRedeem(context, r),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
              ),
            );
          },
        ),
      ),
    );
  }
}
