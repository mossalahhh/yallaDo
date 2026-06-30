import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yallado/features/rewards/data/models/reward_model.dart';
import 'package:yallado/features/rewards/data/reward_service.dart';
import 'rewards_state.dart';

/// Parent reward management: list + add / update / delete / (de)activate.
class RewardsCubit extends Cubit<RewardsState> {
  RewardsCubit() : super(RewardsInitial());

  final RewardService _service = RewardService();
  List<RewardModel> rewards = [];

  Future<void> loadRewards() async {
    emit(RewardsLoading());
    final res = await _service.getRewards();
    final data = res.data;
    if (res.status && data is Map && data['rewards'] is List) {
      rewards = (data['rewards'] as List)
          .map((e) => RewardModel.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
      emit(RewardsLoaded(rewards));
    } else {
      emit(RewardsError(
          res.message.isNotEmpty ? res.message : 'Failed to load rewards'));
    }
  }

  Future<void> _runThenReload(
      Future Function() action, String okFallback) async {
    emit(RewardActionLoading());
    final res = await action();
    if (res.status) {
      emit(RewardActionSuccess(
          res.message.isNotEmpty ? res.message : okFallback));
      await loadRewards();
    } else {
      emit(RewardActionError(
          res.message.isNotEmpty ? res.message : 'Action failed'));
    }
  }

  Future<void> addReward({
    required String name,
    required int points,
    int? quantity,
    String? description,
    XFile? image,
  }) =>
      _runThenReload(
        () => _service.addReward(
            name: name,
            points: points,
            quantity: quantity,
            description: description,
            image: image),
        'Reward added',
      );

  Future<void> updateReward({
    required String id,
    String? name,
    int? points,
    String? description,
    int? quantity,
  }) =>
      _runThenReload(
        () => _service.updateReward(
            id: id,
            name: name,
            points: points,
            description: description,
            quantity: quantity),
        'Reward updated',
      );

  Future<void> deleteReward(String id) =>
      _runThenReload(() => _service.deleteReward(id), 'Reward deleted');

  Future<void> setActive(String id, bool active) => _runThenReload(
        () => active ? _service.reactivate(id) : _service.deactivate(id),
        active ? 'Reward activated' : 'Reward deactivated',
      );
}
