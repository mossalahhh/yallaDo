import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/core/widgets/app_refresh.dart';
import 'package:yallado/features/child/views/widgets/animation.dart';
import 'package:yallado/features/parents/views/widgets/parent_reward_card.dart';
import 'package:yallado/features/rewards/cubit/rewards_cubit/rewards_cubit.dart';
import 'package:yallado/features/rewards/cubit/rewards_cubit/rewards_state.dart';
import 'package:yallado/features/rewards/data/models/reward_model.dart';

class ParentRewards extends StatelessWidget {
  const ParentRewards({super.key});

  static const _palette = [
    Color(0xffa6c7e2),
    Color(0xfffde798),
    Color(0xffbeeba7),
    Color(0xffFFAFCC),
  ];

  void _manage(BuildContext context, RewardModel reward) {
    final cubit = context.read<RewardsCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF9F7F0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(reward.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColor.secondary)),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined,
                  color: AppColor.secondary),
              title: const Text("Edit"),
              onTap: () {
                Navigator.pop(sheetCtx);
                _editDialog(context, reward);
              },
            ),
            ListTile(
              leading: Icon(
                  reward.isActive ? Icons.visibility_off : Icons.visibility,
                  color: AppColor.secondary),
              title: Text(reward.isActive ? "Deactivate" : "Reactivate"),
              onTap: () {
                Navigator.pop(sheetCtx);
                cubit.setActive(reward.id, !reward.isActive);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text("Delete"),
              onTap: () {
                Navigator.pop(sheetCtx);
                cubit.deleteReward(reward.id);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _editDialog(BuildContext context, RewardModel reward) {
    final cubit = context.read<RewardsCubit>();
    final nameC = TextEditingController(text: reward.name);
    final pointsC = TextEditingController(text: '${reward.points}');
    final qtyC = TextEditingController(text: '${reward.quantity}');
    final descC = TextEditingController(text: reward.description);
    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        backgroundColor: const Color(0xFFF9F7F0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Edit Reward",
            style: TextStyle(
                color: AppColor.secondary, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameC,
                  decoration: const InputDecoration(labelText: "Name")),
              TextField(
                  controller: pointsC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Points")),
              TextField(
                  controller: qtyC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Quantity")),
              TextField(
                  controller: descC,
                  decoration: const InputDecoration(labelText: "Description")),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.secondary),
            onPressed: () {
              Navigator.pop(dctx);
              cubit.updateReward(
                id: reward.id,
                name: nameC.text.trim(),
                points: int.tryParse(pointsC.text.trim()),
                quantity: int.tryParse(qtyC.text.trim()),
                description: descC.text.trim(),
              );
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RewardsCubit()..loadRewards(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F7F0),
        body: BlocConsumer<RewardsCubit, RewardsState>(
          listener: (context, state) {
            if (state is RewardActionSuccess) {
              SnackBarPopUp().show(
                  context: context,
                  message: state.message,
                  state: PopUpState.success);
            } else if (state is RewardActionError || state is RewardsError) {
              final msg = state is RewardActionError
                  ? state.message
                  : (state as RewardsError).message;
              SnackBarPopUp().show(
                  context: context, message: msg, state: PopUpState.error);
            }
          },
          builder: (context, state) {
            final rewards = context.read<RewardsCubit>().rewards;
            return AppRefresh(
              onRefresh: () => context.read<RewardsCubit>().loadRewards(),
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
                  const Padding(
                    padding: EdgeInsets.only(left: 30, top: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Awards 🏆',
                          style: TextStyle(
                              color: AppColor.secondary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (state is RewardsLoading && rewards.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(40),
                      child:
                          CircularProgressIndicator(color: AppColor.secondary),
                    )
                  else if (rewards.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(40),
                      child: Text("No rewards yet — add one from the Rewards tab",
                          textAlign: TextAlign.center,
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
                            child: ParentRewardCard(
                              title: r.name,
                              points: r.points,
                              image: r.imageUrl.isNotEmpty
                                  ? r.imageUrl
                                  : 'images/toy.png',
                              color: _palette[i % _palette.length],
                              isActive: r.isActive,
                              onTap: () => _manage(context, r),
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
