import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/features/child/data/child_service.dart';
import 'package:yallado/features/rewards/data/models/reward_model.dart';
import 'package:yallado/features/rewards/data/reward_service.dart';
import 'child_rewards_state.dart';

/// Child reward store: lists rewards + the child's points, and redeems.
class ChildRewardsCubit extends Cubit<ChildRewardsState> {
  ChildRewardsCubit() : super(ChildRewardsInitial());

  final RewardService _service = RewardService();
  final ChildService _childService = ChildService();

  List<RewardModel> rewards = [];
  int points = 0;

  Future<void> load() async {
    emit(ChildRewardsLoading());
    final rewardsRes = await _service.getRewards();
    final pointsRes = await _childService.getMyPoints();
    if (rewardsRes.status &&
        rewardsRes.data is Map &&
        rewardsRes.data['rewards'] is List) {
      rewards = (rewardsRes.data['rewards'] as List)
          .map((e) => RewardModel.fromJson((e as Map).cast<String, dynamic>()))
          // children only see active rewards
          .where((r) => r.isActive)
          .toList();
      points = (pointsRes.status && pointsRes.data is Map)
          ? ((pointsRes.data['points'] as num?)?.toInt() ?? 0)
          : 0;
      emit(ChildRewardsLoaded(rewards, points));
    } else {
      emit(ChildRewardsError(rewardsRes.message.isNotEmpty
          ? rewardsRes.message
          : 'Failed to load rewards'));
    }
  }

  Future<void> redeem(String rewardId) async {
    emit(Redeeming());
    final res = await _service.redeem(rewardId);
    if (res.status) {
      emit(RedeemSuccess(res.message.isNotEmpty ? res.message : 'Redeemed!'));
      await load();
    } else {
      emit(RedeemError(res.message.isNotEmpty ? res.message : 'Could not redeem'));
    }
  }
}
