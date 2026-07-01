import 'package:flutter/foundation.dart';
import 'package:yallado/features/user/data/models/user_model.dart';

/// Shared latest profile.
///
/// The profile screen and the home greeting each build their own
/// [ProfileCubit], so a name/avatar change on one wouldn't show on the other
/// until a manual refresh. Every [ProfileCubit] load publishes here, and
/// screens that display the name/avatar listen to it — so edits appear
/// immediately everywhere, no pull-to-refresh needed.
class ProfileStore {
  ProfileStore._();

  static final ValueNotifier<UserProfile?> profile =
      ValueNotifier<UserProfile?>(null);

  static void set(UserProfile p) => profile.value = p;
}
