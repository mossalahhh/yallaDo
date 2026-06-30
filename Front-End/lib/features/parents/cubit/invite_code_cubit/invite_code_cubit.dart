import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/features/parents/data/models/child_model.dart';
import 'package:yallado/features/parents/data/parent_service.dart';
import 'invite_code_state.dart';

/// Generates a family invite code (`POST parent/invite-code`).
class InviteCodeCubit extends Cubit<InviteCodeState> {
  InviteCodeCubit() : super(InviteCodeInitial());

  final ParentService _service = ParentService();

  Future<void> generate() async {
    emit(InviteCodeLoading());
    final res = await _service.generateInviteCode();
    final data = res.data;
    if (res.status && data is Map && data['results'] != null) {
      emit(InviteCodeLoaded(InviteCode.fromJson(
          (data['results'] as Map).cast<String, dynamic>())));
    } else {
      emit(InviteCodeError(
          res.message.isNotEmpty ? res.message : 'Could not generate code'));
    }
  }
}
