/// Task model for `GET task/tasks` (data[]) and `GET task/:id` (task).
class TaskModel {
  final String taskId;
  final String title;
  final String description;
  final int points;
  final String priority;
  final String category;
  final String type; // personal | open
  final String status; // pending | submitted | approved | rejected | ...
  final String assignedTo;
  final String createdBy;
  final String createdAt;
  final String dueDate;

  final String submissionType; // image
  final int minImages;

  final List<String> submissionImages;
  final String submittedAt;
  final String aiReviewStatus;
  final String aiReviewReasoning;

  final String taskImageUrl;

  const TaskModel({
    required this.taskId,
    required this.title,
    required this.description,
    required this.points,
    required this.priority,
    required this.category,
    required this.type,
    required this.status,
    required this.assignedTo,
    required this.createdBy,
    required this.createdAt,
    required this.dueDate,
    required this.submissionType,
    required this.minImages,
    required this.submissionImages,
    required this.submittedAt,
    required this.aiReviewStatus,
    required this.aiReviewReasoning,
    required this.taskImageUrl,
  });

  bool get isOpen => type == 'open';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
  bool get isSubmitted => status == 'submitted';
  bool get needsImages => submissionType == 'image';

  static int _toInt(dynamic v) =>
      v is num ? v.toInt() : (int.tryParse('$v') ?? 0);

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final req = (json['requirements'] as Map?)?.cast<String, dynamic>() ?? const {};
    final sub = (json['submission'] as Map?)?.cast<String, dynamic>();
    final taskImg = json['taskImage'] ?? json['taskImg'];

    final List<String> images = [];
    if (sub != null && sub['images'] is List) {
      for (final img in (sub['images'] as List)) {
        if (img is Map && img['url'] != null) images.add(img['url'].toString());
      }
    }
    final aiReview = sub != null ? sub['aiReview'] : null;
    final aiResult = aiReview is Map ? aiReview['result'] : null;

    return TaskModel(
      taskId: (json['taskId'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      points: _toInt(json['points']),
      priority: (json['priority'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      assignedTo: (json['assignedTo'] ?? '').toString(),
      createdBy: (json['createdBy'] ?? '').toString(),
      createdAt: (json['createdAt'] ?? '').toString(),
      dueDate: (json['dueDate'] ?? '').toString(),
      submissionType: (req['submissionType'] ?? '').toString(),
      minImages: _toInt(req['minImages']),
      submissionImages: images,
      submittedAt: sub != null ? (sub['submittedAt'] ?? '').toString() : '',
      aiReviewStatus:
          aiReview is Map ? (aiReview['status'] ?? '').toString() : '',
      // The reasoning text lives at `aiReview.reason` (older data used
      // `aiReview.result.reasoning`).
      aiReviewReasoning: aiReview is Map
          ? (aiReview['reason'] ??
                  (aiResult is Map ? aiResult['reasoning'] : null) ??
                  '')
              .toString()
          : '',
      taskImageUrl:
          taskImg is Map ? (taskImg['url']?.toString() ?? '') : '',
    );
  }
}
