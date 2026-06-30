import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yallado/features/tasks/data/task_service.dart';

abstract class CreateTaskState {}

class CreateTaskInitial extends CreateTaskState {}

class CreateTaskLoading extends CreateTaskState {}

class CreateTaskSuccess extends CreateTaskState {
  final String message;
  CreateTaskSuccess(this.message);
}

class CreateTaskError extends CreateTaskState {
  final String message;
  CreateTaskError(this.message);
}

/// Creates a task (`POST task/create`).
class CreateTaskCubit extends Cubit<CreateTaskState> {
  CreateTaskCubit() : super(CreateTaskInitial());

  final TaskService _service = TaskService();

  Future<void> create({
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
  }) async {
    emit(CreateTaskLoading());
    final res = await _service.createTask(
      title: title,
      type: type,
      points: points,
      category: category,
      priority: priority,
      minImages: minImages,
      description: description,
      assignedTo: assignedTo,
      dueDate: dueDate,
      taskImg: taskImg,
    );
    if (res.status) {
      emit(CreateTaskSuccess(
          res.message.isNotEmpty ? res.message : 'Task created'));
    } else {
      emit(CreateTaskError(
          res.message.isNotEmpty ? res.message : 'Could not create task'));
    }
  }
}
