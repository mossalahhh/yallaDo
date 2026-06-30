import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/features/notifications/data/models/notification_model.dart';
import 'package:yallado/features/notifications/data/notification_service.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;
  NotificationsLoaded(this.notifications);
}

class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError(this.message);
}

/// Loads notifications and handles read/delete (single + all).
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  final NotificationService _service = NotificationService();
  List<NotificationModel> notifications = [];

  Future<void> load() async {
    emit(NotificationsLoading());
    final res = await _service.getNotifications();
    final data = res.data;
    // The backend returns the list under `rewards` (a key typo in the
    // controller); fall back across the likely keys so it works either way.
    final list = (data is Map)
        ? (data['notifications'] ??
            data['rewards'] ??
            data['data'] ??
            data['results'])
        : null;
    if (res.status && list is List) {
      notifications = list
          .map((e) =>
              NotificationModel.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
      emit(NotificationsLoaded(notifications));
    } else {
      emit(NotificationsError(
          res.message.isNotEmpty ? res.message : 'Failed to load notifications'));
    }
  }

  Future<void> readOne(String id) async {
    await _service.readOne(id);
    await load();
  }

  Future<void> readAll() async {
    await _service.readAll();
    await load();
  }

  Future<void> deleteOne(String id) async {
    await _service.deleteOne(id);
    await load();
  }

  Future<void> deleteAll() async {
    await _service.deleteAll();
    await load();
  }
}
