import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/features/child/data/child_service.dart';
import 'package:yallado/features/child/data/models/avatar_model.dart';
import 'avatar_state.dart';

/// Loads the child's avatars (`child/avatars`) and points (`child/my-points`),
/// and selects an avatar (`child/:id/select`). The last loaded data is cached
/// so the carousel keeps rendering through the select action.
class AvatarCubit extends Cubit<AvatarState> {
  AvatarCubit() : super(AvatarInitial());

  final ChildService _service = ChildService();
  List<AvatarModel> avatars = [];
  int points = 0;

  Future<void> load() async {
    emit(AvatarLoading());
    final avatarsRes = await _service.getAvatars();
    final pointsRes = await _service.getMyPoints();

    if (avatarsRes.status &&
        avatarsRes.data is Map &&
        avatarsRes.data['avatars'] is List) {
      avatars = (avatarsRes.data['avatars'] as List)
          .map((e) => AvatarModel.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
      points = (pointsRes.status && pointsRes.data is Map)
          ? ((pointsRes.data['points'] as num?)?.toInt() ?? 0)
          : 0;
      emit(AvatarLoaded(avatars, points));
    } else {
      emit(AvatarError(avatarsRes.message.isNotEmpty
          ? avatarsRes.message
          : 'Failed to load avatars'));
    }
  }

  Future<void> selectAvatar(String avatarId) async {
    emit(AvatarSelecting());
    final res = await _service.selectAvatar(avatarId);
    if (res.status) {
      emit(AvatarSelected(
          res.message.isNotEmpty ? res.message : 'Avatar selected'));
      await load();
    } else {
      emit(AvatarSelectError(
          res.message.isNotEmpty ? res.message : 'Could not select avatar'));
    }
  }
}
