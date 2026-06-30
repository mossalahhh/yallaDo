import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yallado/features/user/data/models/user_model.dart';
import 'package:yallado/features/user/data/user_service.dart';
import 'profile_state.dart';

/// Drives the profile screen: loads `user/me`, edits name/userName, and
/// updates/deletes the avatar. The last loaded [profile] is cached so the UI
/// can keep rendering through transient action states.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final UserService _service = UserService();
  UserProfile? profile;

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    final res = await _service.getProfile();
    final data = res.data;
    if (res.status && data is Map && data['profile'] != null) {
      profile = UserProfile.fromJson(
          (data['profile'] as Map).cast<String, dynamic>());
      emit(ProfileLoaded(profile!));
    } else {
      emit(ProfileError(
          res.message.isNotEmpty ? res.message : 'Failed to load profile'));
    }
  }

  Future<void> updateProfile({String? name, String? userName}) async {
    emit(ProfileActionLoading());
    final res = await _service.updateProfile(name: name, userName: userName);
    if (res.status) {
      emit(ProfileActionSuccess(
          res.message.isNotEmpty ? res.message : 'Profile updated'));
      await loadProfile();
    } else {
      emit(ProfileActionError(
          res.message.isNotEmpty ? res.message : 'Update failed'));
    }
  }

  Future<void> updateAvatar(XFile image) async {
    emit(ProfileActionLoading());
    final res = await _service.updateAvatar(image);
    if (res.status) {
      emit(ProfileActionSuccess('Avatar updated'));
      await loadProfile();
    } else {
      emit(ProfileActionError(
          res.message.isNotEmpty ? res.message : 'Avatar update failed'));
    }
  }

  Future<void> deleteAvatar() async {
    emit(ProfileActionLoading());
    final res = await _service.deleteAvatar();
    if (res.status) {
      emit(ProfileActionSuccess('Avatar removed'));
      await loadProfile();
    } else {
      emit(ProfileActionError(
          res.message.isNotEmpty ? res.message : 'Could not remove avatar'));
    }
  }
}
