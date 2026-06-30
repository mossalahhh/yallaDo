import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/features/parents/data/models/child_model.dart';
import 'package:yallado/features/parents/data/parent_service.dart';
import 'child_history_state.dart';

/// Loads a single child's point history (`parent/:id/history`).
class ChildHistoryCubit extends Cubit<ChildHistoryState> {
  ChildHistoryCubit() : super(ChildHistoryInitial());

  final ParentService _service = ParentService();

  Future<void> loadHistory(String childId) async {
    emit(ChildHistoryLoading());
    final res = await _service.getChildHistory(childId);
    final data = res.data;
    if (res.status && data is Map && data['history'] is Map) {
      final list = (data['history']['history'] as List?) ?? const [];
      final entries = list
          .map((e) => HistoryEntry.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
      emit(ChildHistoryLoaded(entries));
    } else {
      emit(ChildHistoryError(
          res.message.isNotEmpty ? res.message : 'Failed to load history'));
    }
  }
}
