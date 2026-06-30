import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/features/child/views/task_details.dart';
import 'package:yallado/features/child/views/widgets/bubble_message.dart';
import 'package:yallado/features/child/views/widgets/task_card.dart';
import 'package:yallado/features/tasks/cubit/tasks_cubit/tasks_cubit.dart';

class ChildTasksView extends StatelessWidget {
  const ChildTasksView({super.key});

  static const _cardColors = [
    Color(0xFFB2E795),
    Color(0xFFFCE9A1),
    Color(0xFFF9C5D0),
    Color(0xFFC4BEEF),
    Color(0xFFB3DCFD),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TasksCubit()..loadTasks(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xfffdfdfd), AppColor.primary],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios,
                            color: AppColor.secondary),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomPaint(
                          painter: BubblePainter(),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(right: 20),
                            child: const Text(
                              'Welcome back! Here are your challenges today!!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColor.secondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Image.asset('images/avatar.png', height: 100, width: 100),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
                      final tasks = context.read<TasksCubit>().tasks;
                      if (tasks.isEmpty) {
                        return const Center(
                            child: Text("No tasks yet",
                                style: TextStyle(
                                    color: AppColor.secondary, fontSize: 16)));
                      }
                      return RefreshIndicator(
                        onRefresh: () =>
                            context.read<TasksCubit>().loadTasks(),
                        child: ListView.builder(
                          padding:
                              const EdgeInsets.only(left: 15, right: 15),
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return TaskCard(
                              color: _cardColors[index % _cardColors.length],
                              title: task.title,
                              points: task.points,
                              status: task.status,
                              isLast: index == tasks.length - 1,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HomeworkDetailScreen(
                                        taskId: task.taskId),
                                  ),
                                );
                                if (context.mounted) {
                                  context.read<TasksCubit>().loadTasks();
                                }
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
