import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_nav.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/core/widgets/tab_scope.dart';
import 'package:yallado/features/parents/views/add_task.dart';
import 'package:yallado/features/parents/views/task_details_parent.dart';
import 'package:yallado/features/parents/views/widgets/task_card_parent.dart';
import 'package:yallado/features/tasks/cubit/tasks_cubit/tasks_cubit.dart';
import 'package:yallado/features/tasks/data/models/task_model.dart';

class ParentTasksView extends StatelessWidget {
  const ParentTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TasksCubit()..loadTasks(),
      child: const _ParentTasksBody(),
    );
  }
}

class _ParentTasksBody extends StatelessWidget {
  const _ParentTasksBody();

  /// Who a task is for: the claimer once claimed, otherwise the assignee
  /// (personal tasks) or "Open task" for an unclaimed public one.
  String _childLabel(TaskModel task) {
    if (task.claimedByName.isNotEmpty) return "Claimed by ${task.claimedByName}";
    if (task.assignedToName.isNotEmpty) return "Assigned to ${task.assignedToName}";
    if (task.isOpen) return "Open task";
    return '';
  }

  /// Opens the Add-Task sheet and refreshes the list when it closes, so a newly
  /// created task shows up right away.
  Future<void> _openAddTask(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTaskBottomSheet(),
    );
    if (context.mounted) context.read<TasksCubit>().loadTasks();
  }

  Widget _buildTaskList(BuildContext context, List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text("No tasks here",
            style: TextStyle(color: Colors.grey, fontSize: 16)),
      );
    }
    return RefreshIndicator(
      onRefresh: () => context.read<TasksCubit>().loadTasks(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskCardParent(
            title: task.title,
            points: task.points,
            status: task.status,
            childLabel: _childLabel(task),
            isLast: index == tasks.length - 1,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ParentTaskDetail(taskId: task.taskId)),
              );
              if (context.mounted) context.read<TasksCubit>().loadTasks();
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F7F0),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton.extended(
            backgroundColor: const Color(0xff4c2d19),
            foregroundColor: Colors.white,
            onPressed: () => _openAddTask(context),
            icon: const Icon(Icons.add),
            label: const Text("Add Task",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => AppNav.back(context,
                          fallback: () => TabScope.of(context)?.goHome()),
                      icon: const Icon(Icons.arrow_back_ios,
                          color: AppColor.secondary),
                    ),
                    const SizedBox(width: 10),
                    const Text("Tasks",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: AppColor.secondary)),
                  ],
                ),
              ),
              const TabBar(
                indicatorColor: Color(0xFF9DC178),
                labelColor: AppColor.secondary,
                unselectedLabelColor: Colors.brown,
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                tabs: [
                  Tab(text: "All"),
                  Tab(text: "Approved"),
                  Tab(text: "Rejected"),
                  Tab(text: "Waited"),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: BlocBuilder<TasksCubit, TasksState>(
                  builder: (context, state) {
                    if (state is TasksLoading || state is TasksInitial) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: AppColor.secondary));
                    }
                    if (state is TasksError) {
                      return Center(
                          child: Text(state.message,
                              style: const TextStyle(
                                  color: AppColor.secondary)));
                    }
                    final all = context.read<TasksCubit>().tasks;
                    final approved =
                        all.where((t) => t.status == 'approved').toList();
                    final rejected =
                        all.where((t) => t.status == 'rejected').toList();
                    // "Waited" = awaiting parent action (submitted / pending).
                    final waited = all
                        .where((t) =>
                            t.status == 'submitted' || t.status == 'pending')
                        .toList();
                    return TabBarView(
                      children: [
                        _buildTaskList(context, all),
                        _buildTaskList(context, approved),
                        _buildTaskList(context, rejected),
                        _buildTaskList(context, waited),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
