import 'package:flutter/foundation.dart';
import 'package:yallado/features/notifications/data/notification_service.dart';

/// Shared unread-notification count for the bottom-nav badge.
///
/// The bottom nav listens to [unread]; the notifications screen updates it
/// whenever the list is (re)loaded — including after reading one / all — so the
/// badge drops immediately instead of only on "clear all".
class NotificationBadge {
  NotificationBadge._();

  static final ValueNotifier<int> unread = ValueNotifier<int>(0);

  /// Sets the count directly from an already-loaded list (instant, no network).
  static void setUnread(int value) => unread.value = value < 0 ? 0 : value;

  /// Fetches the unread count from the server (used by the nav on start /
  /// tab switch, before the notifications screen has been opened).
  static Future<void> refresh() async {
    final res = await NotificationService().count();
    final c = (res.status && res.data is Map) ? res.data['count'] : null;
    if (c is num) unread.value = c.toInt();
  }
}
