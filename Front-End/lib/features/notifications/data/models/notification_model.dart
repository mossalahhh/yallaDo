/// Notification model (defensive — the list endpoint is currently 500ing on the
/// backend; these are the fields a notification carries when created).
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String createdAt;

  /// The entity this notification points at, so tapping can open it.
  /// [relatedModel] is "Task", "Reward" or "Child"; [relatedId] is its id.
  final String relatedId;
  final String relatedModel;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.relatedId = '',
    this.relatedModel = '',
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      // The list returns the id as `notificationId` (not `_id`).
      id: (json['notificationId'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      isRead: json['isRead'] == true,
      createdAt: (json['createdAt'] ?? '').toString(),
      relatedId: (json['relatedId'] ?? '').toString(),
      relatedModel: (json['relatedModel'] ?? '').toString(),
    );
  }
}
