import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/core/widgets/app_network_image.dart';
import 'package:yallado/features/tasks/cubit/task_detail_cubit/task_detail_cubit.dart';
import 'package:yallado/features/tasks/cubit/task_detail_cubit/task_detail_state.dart';
import 'package:yallado/features/tasks/data/models/task_model.dart';

class ParentTaskDetail extends StatelessWidget {
  final String taskId;
  const ParentTaskDetail({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskDetailCubit(taskId)..loadTask(),
      child: const _ParentTaskDetailBody(),
    );
  }
}

class _ParentTaskDetailBody extends StatefulWidget {
  const _ParentTaskDetailBody();

  @override
  State<_ParentTaskDetailBody> createState() => _ParentTaskDetailBodyState();
}

class _ParentTaskDetailBodyState extends State<_ParentTaskDetailBody> {
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void _approve(BuildContext context) =>
      context.read<TaskDetailCubit>().approve();

  void _reject(BuildContext context) {
    if (commentController.text.trim().isEmpty) {
      SnackBarPopUp().show(
          context: context,
          message: "Please add a rejection reason",
          state: PopUpState.warning);
      return;
    }
    context.read<TaskDetailCubit>().reject(commentController.text.trim());
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        backgroundColor: const Color(0xFFF9F7F0),
        title: const Text("Delete Task",
            style: TextStyle(
                color: AppColor.secondary, fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to delete this task?",
            style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dctx),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(dctx);
              context.read<TaskDetailCubit>().delete();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  void _editTask(BuildContext context, TaskModel task) {
    final cubit = context.read<TaskDetailCubit>();
    final titleC = TextEditingController(text: task.title);
    final pointsC = TextEditingController(text: '${task.points}');
    DateTime? due = DateTime.tryParse(task.dueDate);
    final dueC = TextEditingController(text: due != null ? _fmt(due) : '');

    showDialog(
      context: context,
      builder: (dctx) => StatefulBuilder(
        builder: (dctx, setSt) => AlertDialog(
          backgroundColor: const Color(0xFFF9F7F0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Edit Task",
              style: TextStyle(
                  color: AppColor.secondary, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleC,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: pointsC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Points"),
              ),
              TextField(
                controller: dueC,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Due Date"),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: dctx,
                    initialDate: due ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setSt(() {
                      due = picked;
                      dueC.text = _fmt(picked);
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dctx),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColor.secondary),
              onPressed: () {
                final title = titleC.text.trim();
                final points = int.tryParse(pointsC.text.trim());
                if (title.length < 3) {
                  SnackBarPopUp().show(
                      context: dctx,
                      message: "Title must be at least 3 characters",
                      state: PopUpState.warning);
                  return;
                }
                Navigator.pop(dctx);
                cubit.updateTask(
                  title: title,
                  points: points,
                  dueDate: due == null ? null : _fmt(due!),
                );
              },
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      body: SafeArea(
        child: BlocConsumer<TaskDetailCubit, TaskDetailState>(
          listener: (context, state) {
            if (state is TaskActionSuccess) {
              SnackBarPopUp().show(
                  context: context,
                  message: state.message,
                  state: PopUpState.success);
            } else if (state is TaskDeleted) {
              SnackBarPopUp().show(
                  context: context,
                  message: state.message,
                  state: PopUpState.success);
              Navigator.pop(context);
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
                    : const CircularProgressIndicator(
                        color: AppColor.secondary),
              );
            }
            final bool busy = state is TaskActionLoading;
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _imageHeader(context, task),
                      const SizedBox(height: 10),
                      Text(task.title,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColor.secondary)),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                _info("Points", "${task.points}"),
                                const Spacer(),
                                _info("Category", task.category),
                                const Spacer(),
                                _info("Status", task.status),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                _info("Type", task.type),
                                const Spacer(),
                                _info("Priority", task.priority),
                                const Spacer(),
                                _info("Min Photos", "${task.minImages}"),
                              ],
                            ),
                            const SizedBox(height: 24),
                            if (task.description.isNotEmpty) ...[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(task.description,
                                    style: const TextStyle(
                                        color: Colors.grey, height: 1.5)),
                              ),
                              const SizedBox(height: 20),
                            ],
                            if (task.submissionImages.isNotEmpty)
                              _submissionImages(task),
                            if (task.aiReviewStatus.isNotEmpty)
                              _aiReview(task),
                            const SizedBox(height: 16),
                            _comment(),
                            const SizedBox(height: 24),
                            _buttons(context, busy, task.status),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (busy)
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Color(0x11000000),
                      child: Center(
                          child: CircularProgressIndicator(
                              color: AppColor.secondary)),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _imageHeader(BuildContext context, TaskModel task) {
    final url = task.taskImageUrl.isNotEmpty
        ? task.taskImageUrl
        : (task.submissionImages.isNotEmpty
            ? task.submissionImages.first
            : '');
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
          top: 10,
          left: 10,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: AppColor.secondary),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  tooltip: "Edit task",
                  onPressed: () => _editTask(context, task),
                  icon: const Icon(Icons.edit_outlined,
                      color: AppColor.secondary),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  tooltip: "Delete task",
                  onPressed: () => _confirmDelete(context),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _submissionImages(TaskModel task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Submitted Photos",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppColor.secondary)),
        const SizedBox(height: 8),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: task.submissionImages.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AppNetworkImage(task.submissionImages[i],
                  width: 90, height: 90),
            ),
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(task.aiReviewStatus,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
            ],
          ),
          if (task.aiReviewReasoning.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text("Reasoning",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: AppColor.secondary)),
            const SizedBox(height: 4),
            Text(task.aiReviewReasoning,
                style: const TextStyle(color: Colors.grey, height: 1.4)),
          ],
        ],
      ),
    );
  }

  Widget _comment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Rejection Reason (if rejected)",
            style: TextStyle(
                fontWeight: FontWeight.w600, color: AppColor.secondary)),
        const SizedBox(height: 12),
        TextField(
          controller: commentController,
          maxLines: 3,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300)),
          ),
        ),
      ],
    );
  }

  Widget _buttons(BuildContext context, bool busy, String status) {
    // Once a task is approved/rejected the decision is final, so both buttons
    // go idle (grey + unclickable). Only the pending/submitted state is live.
    final s = status.toLowerCase();
    final isApproved = s == 'approved';
    final isRejected = s == 'rejected';
    final done = isApproved || isRejected;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: (busy || done) ? null : () => _approve(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              disabledBackgroundColor: Colors.grey.shade400,
              disabledForegroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            icon: Icon(Icons.check_circle_outline,
                color: (busy || done) ? Colors.white70 : Colors.white),
            label: Text(isApproved ? "Approved" : "Approve",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: (busy || done) ? null : () => _reject(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              disabledBackgroundColor: Colors.grey.shade400,
              disabledForegroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            icon: Icon(Icons.cancel_outlined,
                color: (busy || done) ? Colors.white70 : Colors.white),
            label: Text(isRejected ? "Rejected" : "Reject",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _info(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColor.secondary)),
        const SizedBox(height: 6),
        Text(value.isEmpty ? '—' : value,
            style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }
}
