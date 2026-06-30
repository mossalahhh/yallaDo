import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/features/child/data/child_service.dart';

abstract class LinkState {}

class LinkInitial extends LinkState {}

class LinkLoading extends LinkState {}

class LinkSuccess extends LinkState {
  final String message;
  LinkSuccess(this.message);
}

class LinkError extends LinkState {
  final String message;
  LinkError(this.message);
}

/// Links a child to a parent via family code (`POST child/link-accounts`).
class LinkCubit extends Cubit<LinkState> {
  LinkCubit() : super(LinkInitial());

  final ChildService _service = ChildService();

  Future<void> linkAccount(String code) async {
    emit(LinkLoading());
    final res = await _service.linkAccount(code);
    if (res.status) {
      emit(LinkSuccess(res.message.isNotEmpty ? res.message : 'Account linked'));
    } else {
      emit(LinkError(res.message.isNotEmpty ? res.message : 'Invalid code'));
    }
  }
}
