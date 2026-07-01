import 'package:flutter/material.dart';
import 'package:yallado/features/child/views/child_rewards_view.dart';
import 'package:yallado/features/child/views/task_details.dart';
import 'package:yallado/features/notifications/data/models/notification_model.dart';
import 'package:yallado/features/parents/views/readmore_details.dart';
import 'package:yallado/features/parents/views/rewards.dart';
import 'package:yallado/features/parents/views/task_details_parent.dart';

/// Maps a tapped notification to the screen it refers to, based on the
/// backend's `relatedModel` / `relatedId`. Returns null when there's nothing
/// meaningful to open (the tap then just marks it read).
///
/// The child and parent apps open different screens for the same entity, so the
/// two helpers below are kept separate.
Widget? childNotificationDestination(NotificationModel n) {
  switch (n.relatedModel) {
    case 'Task':
      return n.relatedId.isEmpty ? null : HomeworkDetailScreen(taskId: n.relatedId);
    case 'Reward':
    case 'Child': // points added/removed → let them see their rewards/points
      return const ChildRewardsView();
    default:
      return null;
  }
}

Widget? parentNotificationDestination(NotificationModel n) {
  switch (n.relatedModel) {
    case 'Task':
      return n.relatedId.isEmpty ? null : ParentTaskDetail(taskId: n.relatedId);
    case 'Reward':
      return const ParentRewards();
    case 'Child':
      return n.relatedId.isEmpty
          ? null
          : MoreDetailsScreen(childId: n.relatedId, name: '');
    default:
      return null;
  }
}
