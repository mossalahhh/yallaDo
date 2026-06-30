import 'package:yallado/features/parents/data/models/child_model.dart';

abstract class InviteCodeState {}

class InviteCodeInitial extends InviteCodeState {}

class InviteCodeLoading extends InviteCodeState {}

class InviteCodeLoaded extends InviteCodeState {
  final InviteCode invite;
  InviteCodeLoaded(this.invite);
}

class InviteCodeError extends InviteCodeState {
  final String message;
  InviteCodeError(this.message);
}
