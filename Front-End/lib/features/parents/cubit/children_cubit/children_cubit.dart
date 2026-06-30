import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/features/parents/data/models/child_model.dart';
import 'package:yallado/features/parents/data/parent_service.dart';
import 'children_state.dart';

/// Loads the parent's linked children (`parent/children`) and unlinks them.
/// Shared by the parent home list, the unlink sheet, and the history selector.
class ChildrenCubit extends Cubit<ChildrenState> {
  ChildrenCubit() : super(ChildrenInitial());

  final ParentService _service = ParentService();
  List<ChildSummary> children = [];

  Future<void> loadChildren() async {
    emit(ChildrenLoading());
    final res = await _service.getChildren();
    final data = res.data;
    if (res.status && data is Map && data['results'] is List) {
      children = (data['results'] as List)
          .map((e) => ChildSummary.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
      emit(ChildrenLoaded(children));
    } else {
      emit(ChildrenError(
          res.message.isNotEmpty ? res.message : 'Failed to load children'));
    }
  }

  Future<void> unlinkChild(String childId) async {
    emit(ChildActionLoading());
    final res = await _service.unlinkChild(childId);
    if (res.status) {
      emit(ChildUnlinked(
          res.message.isNotEmpty ? res.message : 'Child unlinked'));
      await loadChildren();
    } else {
      emit(ChildActionError(
          res.message.isNotEmpty ? res.message : 'Could not unlink child'));
    }
  }
}
