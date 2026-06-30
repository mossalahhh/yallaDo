import 'package:yallado/features/rewards/data/models/reward_model.dart';

abstract class ChildRewardsState {}

class ChildRewardsInitial extends ChildRewardsState {}

class ChildRewardsLoading extends ChildRewardsState {}

class ChildRewardsLoaded extends ChildRewardsState {
  final List<RewardModel> rewards;
  final int points;
  ChildRewardsLoaded(this.rewards, this.points);
}

class ChildRewardsError extends ChildRewardsState {
  final String message;
  ChildRewardsError(this.message);
}

class Redeeming extends ChildRewardsState {}

class RedeemSuccess extends ChildRewardsState {
  final String message;
  RedeemSuccess(this.message);
}

class RedeemError extends ChildRewardsState {
  final String message;
  RedeemError(this.message);
}
