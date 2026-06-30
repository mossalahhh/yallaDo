import 'package:yallado/features/tasks/data/models/task_model.dart';

abstract class TaskDetailState {}

class TaskDetailInitial extends TaskDetailState {}

class TaskDetailLoading extends TaskDetailState {}

class TaskDetailLoaded extends TaskDetailState {
  final TaskModel task;
  TaskDetailLoaded(this.task);
}

class TaskDetailError extends TaskDetailState {
  final String message;
  TaskDetailError(this.message);
}

class TaskActionLoading extends TaskDetailState {}

class TaskActionSuccess extends TaskDetailState {
  final String message;
  TaskActionSuccess(this.message);
}

/// Emitted after a successful delete so the screen can pop.
class TaskDeleted extends TaskDetailState {
  final String message;
  TaskDeleted(this.message);
}

class TaskActionError extends TaskDetailState {
  final String message;
  TaskActionError(this.message);
}
