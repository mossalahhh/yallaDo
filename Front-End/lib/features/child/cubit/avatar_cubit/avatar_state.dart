import 'package:yallado/features/child/data/models/avatar_model.dart';

abstract class AvatarState {}

class AvatarInitial extends AvatarState {}

class AvatarLoading extends AvatarState {}

class AvatarLoaded extends AvatarState {
  final List<AvatarModel> avatars;
  final int points;
  AvatarLoaded(this.avatars, this.points);
}

class AvatarError extends AvatarState {
  final String message;
  AvatarError(this.message);
}

class AvatarSelecting extends AvatarState {}

class AvatarSelected extends AvatarState {
  final String message;
  AvatarSelected(this.message);
}

class AvatarSelectError extends AvatarState {
  final String message;
  AvatarSelectError(this.message);
}
