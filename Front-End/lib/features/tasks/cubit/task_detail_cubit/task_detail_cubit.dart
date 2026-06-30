import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yallado/features/tasks/data/models/task_model.dart';
import 'package:yallado/features/tasks/data/task_service.dart';
import 'task_detail_state.dart';

/// Drives a single task: loads it (`task/:id`) and runs the lifecycle actions
/// (claim, submit, approve, reject, delete). The last loaded [task] is cached
/// so the screen keeps rendering through transient action states.
class TaskDetailCubit extends Cubit<TaskDetailState> {
  TaskDetailCubit(this.taskId) : super(TaskDetailInitial());

  final String taskId;
  final TaskService _service = TaskService();
  TaskModel? task;

  Future<void> loadTask() async {
    emit(TaskDetailLoading());
    final res = await _service.getTask(taskId);
    final data = res.data;
    if (res.status && data is Map && data['task'] != null) {
      task = TaskModel.fromJson((data['task'] as Map).cast<String, dynamic>());
      emit(TaskDetailLoaded(task!));
    } else {
      emit(TaskDetailError(
          res.message.isNotEmpty ? res.message : 'Failed to load task'));
    }
  }

  Future<void> _runThenReload(
      Future Function() action, String okFallback) async {
    emit(TaskActionLoading());
    final res = await action();
    if (res.status) {
      emit(TaskActionSuccess(res.message.isNotEmpty ? res.message : okFallback));
      await loadTask();
    } else {
      emit(TaskActionError(
          res.message.isNotEmpty ? res.message : 'Action failed'));
    }
  }

  Future<void> claim() =>
      _runThenReload(() => _service.claimTask(taskId), 'Task claimed');

  Future<void> submit({required List<XFile> images, String? description}) =>
      _runThenReload(
        () => _service.submitTask(
            taskId: taskId, images: images, description: description),
        'Task submitted',
      );

  Future<void> updateTask({String? title, int? points, String? dueDate}) =>
      _runThenReload(
        () => _service.updateTask(
            taskId: taskId, title: title, points: points, dueDate: dueDate),
        'Task updated',
      );

  Future<void> approve() =>
      _runThenReload(() => _service.approveTask(taskId), 'Task approved');

  Future<void> reject(String reason) =>
      _runThenReload(() => _service.rejectTask(taskId, reason), 'Task rejected');

  Future<void> delete() async {
    emit(TaskActionLoading());
    final res = await _service.deleteTask(taskId);
    if (res.status) {
      emit(TaskDeleted(res.message.isNotEmpty ? res.message : 'Task deleted'));
    } else {
      emit(TaskActionError(
          res.message.isNotEmpty ? res.message : 'Could not delete task'));
    }
  }
}
