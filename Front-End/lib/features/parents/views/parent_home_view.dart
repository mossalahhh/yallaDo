import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/core/widgets/app_error_retry.dart';
import 'package:yallado/features/parents/cubit/analytics_cubit/analytics_cubit.dart';
import 'package:yallado/features/parents/cubit/children_cubit/children_cubit.dart';
import 'package:yallado/features/parents/cubit/children_cubit/children_state.dart';
import 'package:yallado/features/parents/views/add_task.dart';
import 'package:yallado/features/parents/views/notifications.dart';
import 'package:yallado/features/parents/views/track_behavior.dart';
import 'package:yallado/features/parents/views/widgets/kidcard.dart';
import 'package:yallado/features/parents/views/widgets/sidemenu.dart';
import 'package:yallado/features/user/cubit/profile_cubit/profile_cubit.dart';
import 'package:yallado/features/user/cubit/profile_cubit/profile_state.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ChildrenCubit()..loadChildren()),
        BlocProvider(create: (_) => ProfileCubit()..loadProfile()),
        BlocProvider(create: (_) => AnalyticsCubit()..loadAll()),
      ],
      child: Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff4c2d19),
        foregroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const AddTaskBottomSheet(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Task",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Color(0xFFF9F7F0),
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _buildHeader(),
              Positioned(
                right: 0,
                left: 0,
                bottom: -130,
                child: _buildProgressCard(),
              ),
            ],
          ),
          const SizedBox(height: 150),
          Expanded(child: _buildKidsList()),
        ],
      ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 300,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xffd0e1c3),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.menu, color: Color(0xff4c2d19)),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withOpacity(0.3),
                      builder: (_) => SideMenuPopup(),
                    );
                  },
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ParentNotificationsView(),));
                  },
                  icon: Icon(
                    Icons.notifications_none,
                    size: 30,
                    color: Color(0xff4c2d19),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final name = context.read<ProfileCubit>().profile?.user.name;
                return Text(
                  "Hello, ${name != null && name.isNotEmpty ? name : 'Parent'} !",
                  style: const TextStyle(
                    color: Color(0xff4c2d19),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            const Text(
              "Help Your Family To be more calm and productive",
              style: TextStyle(
                color: Color(0xff4c2d19),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrackBehaviorView(),));
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Progress Track Behavior",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              BlocBuilder<AnalyticsCubit, AnalyticsState>(
                builder: (context, state) {
                  final progress = context.read<AnalyticsCubit>().progress;
                  if (state is AnalyticsLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                          child: CircularProgressIndicator(
                              color: Color(0xff4c2d19))),
                    );
                  }
                  if (progress.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text("No children linked yet",
                          style: TextStyle(color: Colors.grey)),
                    );
                  }
                  final shown = progress.take(3).toList();
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: shown
                        .map((p) => _buildBar(
                              p.childName,
                              (p.approvedPercentage / 100).clamp(0.0, 1.0),
                              "${p.approvedPercentage}%",
                            ))
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBar(String name, double value, String topLabel) {
    return Column(
      children: [
        Text(topLabel,
            style: const TextStyle(fontSize: 12, color: Color(0xff4c2d19))),
        const SizedBox(height: 6),
        Container(
          height: 75,
          width: 22,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 90 * value,
            width: 22,
            decoration: BoxDecoration(
              color: const Color(0xffcfe0c2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(name),
      ],
    );
  }

  Widget _buildKidsList() {
    return BlocBuilder<ChildrenCubit, ChildrenState>(
      builder: (context, state) {
        final children = context.read<ChildrenCubit>().children;
        if (children.isEmpty) {
          if (state is ChildrenLoading || state is ChildrenInitial) {
            return const Center(
                child: CircularProgressIndicator(color: AppColor.secondary));
          }
          if (state is ChildrenError) {
            return AppErrorRetry(
              message: state.message,
              onRetry: () => context.read<ChildrenCubit>().loadChildren(),
            );
          }
          return const Center(
            child: Text("No children linked yet",
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          );
        }
        return RefreshIndicator(
          onRefresh: () => context.read<ChildrenCubit>().loadChildren(),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: children.length,
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final child = children[index];
              return KidCard(
                childId: child.childId,
                name: child.name,
                age: "${child.age}",
                avatarUrl: child.avatarUrl,
                totalPoints: child.totalPoints,
              );
            },
          ),
        );
      },
    );
  }
}



