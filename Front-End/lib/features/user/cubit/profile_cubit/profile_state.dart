import 'package:yallado/features/user/data/models/user_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

/// Transient states for edit-name / avatar actions (kept separate from the
/// load lifecycle so the screen can keep showing the cached profile).
class ProfileActionLoading extends ProfileState {}

class ProfileActionSuccess extends ProfileState {
  final String message;
  ProfileActionSuccess(this.message);
}

class ProfileActionError extends ProfileState {
  final String message;
  ProfileActionError(this.message);
}
