import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/features/parents/data/models/child_model.dart';
import 'package:yallado/features/parents/data/parent_service.dart';
import 'child_details_state.dart';

/// Loads a single child's details (`parent/:id/details`) and adjusts points
/// (`parent/:id/adjust-points`). Used by MoreDetailsScreen + the adjust dialog.
class ChildDetailsCubit extends Cubit<ChildDetailsState> {
  ChildDetailsCubit(this.childId) : super(ChildDetailsInitial());

  final String childId;
  final ParentService _service = ParentService();
  ChildDetails? details;

  Future<void> loadDetails() async {
    emit(ChildDetailsLoading());
    final res = await _service.getChildDetails(childId);
    final data = res.data;
    if (res.status && data is Map && data['results'] != null) {
      details = ChildDetails.fromJson(
          (data['results'] as Map).cast<String, dynamic>());
      emit(ChildDetailsLoaded(details!));
    } else {
      emit(ChildDetailsError(
          res.message.isNotEmpty ? res.message : 'Failed to load details'));
    }
  }

  /// [type] is `add` or `remove`.
  Future<void> adjustPoints({
    required String type,
    required int points,
    required String reason,
  }) async {
    emit(PointsAdjusting());
    final res = await _service.adjustPoints(
      childId: childId,
      type: type,
      points: points,
      reason: reason,
    );
    if (res.status) {
      emit(PointsAdjusted(
          res.message.isNotEmpty ? res.message : 'Points updated'));
      await loadDetails();
    } else {
      emit(PointsAdjustError(
          res.message.isNotEmpty ? res.message : 'Could not adjust points'));
    }
  }
}
