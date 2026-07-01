import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/core/widgets/app_error_retry.dart';
import 'package:yallado/features/parents/cubit/child_history_cubit/child_history_cubit.dart';
import 'package:yallado/features/parents/cubit/child_history_cubit/child_history_state.dart';
import 'package:yallado/features/parents/cubit/children_cubit/children_cubit.dart';
import 'package:yallado/features/parents/cubit/children_cubit/children_state.dart';
import 'package:yallado/features/parents/views/widgets/history_widget.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ChildrenCubit()..loadChildren()),
        BlocProvider(create: (_) => ChildHistoryCubit()),
      ],
      child: const _HistoryBody(),
    );
  }
}

class _HistoryBody extends StatefulWidget {
  const _HistoryBody();

  @override
  State<_HistoryBody> createState() => _HistoryBodyState();
}

class _HistoryBodyState extends State<_HistoryBody> {
  int? selectedChildIndex;
  String selectedChildName = '';
  String? selectedChildId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios,
                        color: AppColor.secondary),
                  ),
                  const SizedBox(width: 10),
                  const Text("History",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColor.secondary)),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Choose Child",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              BlocBuilder<ChildrenCubit, ChildrenState>(
                builder: (context, state) {
                  final children = context.read<ChildrenCubit>().children;
                  if (children.isEmpty && state is ChildrenLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(
                          color: AppColor.secondary),
                    );
                  }
                  if (children.isEmpty) {
                    return const Text("No children linked",
                        style: TextStyle(color: Colors.grey));
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        children.length,
                        (index) => HistoryChildAvatar(
                          index: index,
                          selectedIndex: selectedChildIndex,
                          name: children[index].name,
                          image: children[index].avatarUrl.isNotEmpty
                              ? children[index].avatarUrl
                              : "images/avatar1.png",
                          onTap: () {
                            setState(() {
                              selectedChildIndex = index;
                              selectedChildName = children[index].name;
                              selectedChildId = children[index].childId;
                            });
                            context
                                .read<ChildHistoryCubit>()
                                .loadHistory(children[index].childId);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: selectedChildIndex == null
                    ? const Center(
                        child: Text("Please select a child",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 16)),
                      )
                    : BlocBuilder<ChildHistoryCubit, ChildHistoryState>(
                        builder: (context, state) {
                          if (state is ChildHistoryLoading) {
                            return const Center(
                                child: CircularProgressIndicator(
                                    color: AppColor.secondary));
                          }
                          if (state is ChildHistoryError) {
                            return AppErrorRetry(
                              message: state.message,
                              onRetry: () {
                                final id = selectedChildId;
                                if (id != null) {
                                  context
                                      .read<ChildHistoryCubit>()
                                      .loadHistory(id);
                                }
                              },
                            );
                          }
                          if (state is ChildHistoryLoaded) {
                            if (state.entries.isEmpty) {
                              return const Center(
                                  child: Text("No history yet",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16)));
                            }
                            return RefreshIndicator(
                              color: AppColor.secondary,
                              onRefresh: () {
                                final id = selectedChildId;
                                return id != null
                                    ? context
                                        .read<ChildHistoryCubit>()
                                        .loadHistory(id)
                                    : Future.value();
                              },
                              child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: state.entries.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final item = state.entries[index];
                                return HistoryCard(
                                  childName: selectedChildName,
                                  points: "${item.points}",
                                  type: item.type,
                                  source: item.source,
                                  reason: item.reason,
                                );
                              },
                            ),
                            );
                          }
                          return const SizedBox.shrink();
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
