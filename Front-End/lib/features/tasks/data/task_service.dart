import 'package:image_picker/image_picker.dart';
import 'package:yallado/core/network/api_helper.dart';
import 'package:yallado/core/network/api_response.dart';
import 'package:yallado/core/network/upload_helper.dart';

/// Data layer for Module 5 (Tasks Engine). All requests are protected.
class TaskService {
  final ApiHelper _api = ApiHelper();

  Future<ApiResponse> _safe(Future<ApiResponse> Function() call) async {
    try {
      return await call();
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  Future<ApiResponse> getTasks({int page = 1, String? type}) {
    return _safe(() => _api.getRequest(
          endPoint: 'task/tasks',
          isProtected: true,
          queryParameters: {
            'page': page,
            if (type != null) 'type': type,
          },
        ));
  }

  Future<ApiResponse> getTask(String taskId) {
    return _safe(
        () => _api.getRequest(endPoint: 'task/$taskId', isProtected: true));
  }

  /// POST `task/create` — multipart.
  ///
  /// Backend contract:
  ///  * photos required → send `submissionType: "image"` + `minImages >= 1`;
  ///  * no photos       → omit `submissionType` (server defaults to "text")
  ///    and send `minImages: 0`.
  /// So [minImages] >= 1 means "photo task". `taskImg` is an optional cover image.
  Future<ApiResponse> createTask({
    required String title,
    required String type,
    required int points,
    required String category,
    required String priority,
    required int minImages,
    String? description,
    String? assignedTo,
    String? dueDate,
    XFile? taskImg,
  }) {
    return _safe(() async {
      final bool requiresPhoto = minImages >= 1;
      final data = <String, dynamic>{
        'title': title,
        'type': type,
        'points': '$points',
        'category': category,
        'priority': priority,
        if (requiresPhoto) 'submissionType': 'image',
        'minImages': '${requiresPhoto ? minImages : 0}',
        if (description != null && description.isNotEmpty)
          'description': description,
        if (assignedTo != null && assignedTo.isNotEmpty)
          'assignedTo': assignedTo,
        if (dueDate != null && dueDate.isNotEmpty) 'dueDate': dueDate,
        if (taskImg != null) 'taskImg': await multipartFromXFile(taskImg),
      };
      return _api.postRequest(
          endPoint: 'task/create',
          isProtected: true,
          isFormData: true,
          data: data);
    });
  }

  Future<ApiResponse> claimTask(String taskId) {
    return _safe(() => _api.patchRequest(
        endPoint: 'task/$taskId/claim', isProtected: true));
  }

  /// PATCH `task/:id/submit` — multipart `submitImgs` (a list value becomes
  /// repeated form-data entries) plus an optional description. Web-safe.
  Future<ApiResponse> submitTask({
    required String taskId,
    required List<XFile> images,
    String? description,
  }) {
    return _safe(() async {
      final files = <dynamic>[];
      for (final img in images) {
        files.add(await multipartFromXFile(img));
      }
      return _api.patchRequest(
        endPoint: 'task/$taskId/submit',
        isProtected: true,
        isFormData: true,
        data: {
          if (description != null && description.isNotEmpty)
            'description': description,
          'submitImgs': files,
        },
      );
    });
  }

  /// PATCH `task/:id/update` (JSON). The backend only allows `title`, `points`
  /// and `dueDate` to be edited.
  Future<ApiResponse> updateTask({
    required String taskId,
    String? title,
    int? points,
    String? dueDate,
  }) {
    return _safe(() => _api.patchRequest(
          endPoint: 'task/$taskId/update',
          isProtected: true,
          data: {
            if (title != null && title.isNotEmpty) 'title': title,
            if (points != null) 'points': points,
            if (dueDate != null && dueDate.isNotEmpty) 'dueDate': dueDate,
          },
        ));
  }

  Future<ApiResponse> approveTask(String taskId) {
    return _safe(() => _api.patchRequest(
        endPoint: 'task/$taskId/approve', isProtected: true));
  }

  Future<ApiResponse> rejectTask(String taskId, String rejectionReason) {
    return _safe(() => _api.patchRequest(
          endPoint: 'task/$taskId/reject',
          isProtected: true,
          data: {'rejectionReason': rejectionReason},
        ));
  }

  Future<ApiResponse> deleteTask(String taskId) {
    return _safe(() => _api.patchRequest(
        endPoint: 'task/$taskId/delete', isProtected: true));
  }
}
