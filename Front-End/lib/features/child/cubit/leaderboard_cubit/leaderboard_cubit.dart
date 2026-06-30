import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/features/child/data/child_service.dart';
import 'package:yallado/features/child/data/models/leader_model.dart';

abstract class LeaderboardState {}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final List<LeaderModel> top3;
  final int myRank;
  LeaderboardLoaded(this.top3, this.myRank);
}

class LeaderboardError extends LeaderboardState {
  final String message;
  LeaderboardError(this.message);
}

/// Loads the top-3 leaderboard (`child/top-children`).
class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit() : super(LeaderboardInitial());

  final ChildService _service = ChildService();

  Future<void> load() async {
    emit(LeaderboardLoading());
    final res = await _service.getTopChildren();
    final data = res.data;
    if (res.status && data is Map && data['top3'] is List) {
      final top3 = (data['top3'] as List)
          .map((e) => LeaderModel.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
      final myRank = data['myRank'] is num ? (data['myRank'] as num).toInt() : 0;
      emit(LeaderboardLoaded(top3, myRank));
    } else {
      emit(LeaderboardError(
          res.message.isNotEmpty ? res.message : 'Failed to load leaderboard'));
    }
  }
}
