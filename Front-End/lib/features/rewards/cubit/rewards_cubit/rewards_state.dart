import 'package:yallado/features/rewards/data/models/reward_model.dart';

abstract class RewardsState {}

class RewardsInitial extends RewardsState {}

class RewardsLoading extends RewardsState {}

class RewardsLoaded extends RewardsState {
  final List<RewardModel> rewards;
  RewardsLoaded(this.rewards);
}

class RewardsError extends RewardsState {
  final String message;
  RewardsError(this.message);
}

class RewardActionLoading extends RewardsState {}

class RewardActionSuccess extends RewardsState {
  final String message;
  RewardActionSuccess(this.message);
}

class RewardActionError extends RewardsState {
  final String message;
  RewardActionError(this.message);
}
