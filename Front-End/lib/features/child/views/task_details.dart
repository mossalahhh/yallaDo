import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/features/tasks/cubit/task_detail_cubit/task_detail_cubit.dart';
import 'package:yallado/features/tasks/cubit/task_detail_cubit/task_detail_state.dart';
import 'package:yallado/features/tasks/data/models/task_model.dart';

class HomeworkDetailScreen extends StatelessWidget {
  final String taskId;
  const HomeworkDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskDetailCubit(taskId)..loadTask(),
      child: const _HomeworkDetailBody(),
    );
  }
}

class _HomeworkDetailBody extends StatefulWidget {
  const _HomeworkDetailBody();

  @override
  State<_HomeworkDetailBody> createState() => _HomeworkDetailBodyState();
}

class _HomeworkDetailBodyState extends State<_HomeworkDetailBody> {
  final List<XFile> _picked = [];

  Future<void> _pickImage() async {
    final img =
        await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (img != null) setState(() => _picked.add(img));
  }

  void _submit(BuildContext context, TaskModel task) {
    // minImages == 0 → no photo required; submit can go with an empty list.
    if (_picked.length < task.minImages) {
      SnackBarPopUp().show(
          context: context,
          message: "Please add at least ${task.minImages} photo(s)",
          state: PopUpState.warning);
      return;
    }
    context.read<TaskDetailCubit>().submit(images: _picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      body: BlocConsumer<TaskDetailCubit, TaskDetailState>(
        listener: (context, state) {
          if (state is TaskActionSuccess) {
            SnackBarPopUp().show(
                context: context,
                message: state.message,
                state: PopUpState.success);
            setState(() => _picked.clear());
          } else if (state is TaskActionError || state is TaskDetailError) {
            final msg = state is TaskActionError
                ? state.message
                : (state as TaskDetailError).message;
            SnackBarPopUp().show(
                context: context, message: msg, state: PopUpState.error);
          }
        },
        builder: (context, state) {
          final cubit = context.read<TaskDetailCubit>();
          final task = cubit.task;
          if (task == null) {
            return Center(
              child: state is TaskDetailError
                  ? Text(state.message,
                      style: const TextStyle(color: AppColor.secondary))
                  : const CircularProgressIndicator(color: AppColor.secondary),
            );
          }
          final bool busy = state is TaskActionLoading;
          final bool canClaim = task.isOpen && task.status == 'pending';
          final bool canSubmit = !canClaim &&
              task.status != 'approved' &&
              task.status != 'submitted';
          return Column(
            children: [
              _hero(context, task),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(task.title,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColor.secondary)),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _info("Points", "${task.points}"),
                          const Spacer(),
                          _info("Status", task.status),
                          const Spacer(),
                          _info("Photos", "${task.minImages}"),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (task.description.isNotEmpty) ...[
                        const Text("How To Do The Task?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColor.secondary)),
                        const SizedBox(height: 8),
                        Text(task.description,
                            style: const TextStyle(
                                color: Colors.grey, height: 1.6)),
                        const SizedBox(height: 24),
                      ],
                      Row(
                        children: [
                          _info("Type", task.type),
                          const Spacer(),
                          _info("Priority", task.priority),
                          const Spacer(),
                          _info("Category", task.category),
                        ],
                      ),
                      if (task.aiReviewStatus.isNotEmpty) _aiReview(task),
                      const SizedBox(height: 24),
                      if (canSubmit) _photoPicker(task),
                    ],
                  ),
                ),
              ),
              _bottomButton(context, task, canClaim, canSubmit, busy),
            ],
          );
        },
      ),
    );
  }

  Widget _hero(BuildContext context, TaskModel task) {
    final url = task.taskImageUrl;
    return Stack(
      children: [
        SizedBox(
          height: 240,
          width: double.infinity,
          child: url.isNotEmpty
              ? Image.network(url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Image.asset('images/task.jpg', fit: BoxFit.cover))
              : Image.asset('images/task.jpg', fit: BoxFit.cover),
        ),
        Positioned(
          top: 40,
          left: 10,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: AppColor.secondary),
          ),
        ),
      ],
    );
  }

  Widget _aiReview(TaskModel task) {
    final approved = task.aiReviewStatus.toLowerCase() == 'approved';
    final color = approved
        ? Colors.green
        : (task.aiReviewStatus.toLowerCase() == 'rejected'
            ? Colors.red
            : Colors.orange);
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.smart_toy_outlined, color: AppColor.secondary),
              const SizedBox(width: 8),
              const Text("AI Review",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColor.secondary)),
              const Spacer(),
              Text(task.aiReviewStatus,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          if (task.aiReviewReasoning.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(task.aiReviewReasoning,
                style: const TextStyle(color: Colors.grey, height: 1.4)),
          ],
        ],
      ),
    );
  }

  Widget _photoPicker(TaskModel task) {
    final optional = task.minImages == 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(optional ? "Your Photos (optional)" : "Your Photos",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColor.secondary)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._picked.map((f) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _Thumb(file: f),
                )),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: const Color(0xFFDDD5C8), width: 1.5),
                ),
                child: const Icon(Icons.camera_alt_outlined,
                    color: AppColor.secondary),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _bottomButton(BuildContext context, TaskModel task, bool canClaim,
      bool canSubmit, bool busy) {
    String label;
    VoidCallback? onPressed;
    if (canClaim) {
      label = "Claim Task";
      onPressed = busy ? null : () => context.read<TaskDetailCubit>().claim();
    } else if (canSubmit) {
      label = "Send";
      onPressed = busy ? null : () => _submit(context, task);
    } else {
      label = task.status == 'approved'
          ? "Approved 🌟"
          : task.status == 'submitted'
              ? "Waiting for review…"
              : task.status;
      onPressed = null;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 8),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B2A1A),
            disabledBackgroundColor: const Color(0xFF9BC16C),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 0,
          ),
          child: busy
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5))
              : Text(label,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
        ),
      ),
    );
  }

  Widget _info(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColor.secondary,
                fontSize: 13)),
        const SizedBox(height: 6),
        Text(value.isEmpty ? '—' : value,
            style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }
}

/// Web-safe thumbnail for a picked [XFile] (uses bytes, not dart:io File).
class _Thumb extends StatelessWidget {
  final XFile file;
  const _Thumb({required this.file});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: file.readAsBytes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
              width: 70, height: 70, color: Colors.grey.shade200);
        }
        return Image.memory(snapshot.data!,
            width: 70, height: 70, fit: BoxFit.cover);
      },
    );
  }
}
