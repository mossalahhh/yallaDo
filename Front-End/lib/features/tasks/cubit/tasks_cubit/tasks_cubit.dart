import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/features/tasks/data/models/task_model.dart';
import 'package:yallado/features/tasks/data/task_service.dart';

abstract class TasksState {}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoaded extends TasksState {
  final List<TaskModel> tasks;
  TasksLoaded(this.tasks);
}

class TasksError extends TasksState {
  final String message;
  TasksError(this.message);
}

/// Loads the task list (`GET task/tasks`). Shared by the parent + child task
/// screens. [type] filters open vs personal when needed.
class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());

  final TaskService _service = TaskService();
  List<TaskModel> tasks = [];

  Future<void> loadTasks({String? type, int page = 1}) async {
    emit(TasksLoading());
    final res = await _service.getTasks(page: page, type: type);
    final data = res.data;
    if (res.status && data is Map && data['data'] is List) {
      tasks = (data['data'] as List)
          .map((e) => TaskModel.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
      emit(TasksLoaded(tasks));
    } else {
      emit(TasksError(
          res.message.isNotEmpty ? res.message : 'Failed to load tasks'));
    }
  }
}
