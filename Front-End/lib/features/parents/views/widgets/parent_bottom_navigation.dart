import 'package:flutter/material.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/core/widgets/tab_scope.dart';
import 'package:yallado/features/notifications/notification_badge.dart';
import 'package:yallado/features/parents/views/add_reward.dart';
import 'package:yallado/features/parents/views/notifications.dart';
import 'package:yallado/features/parents/views/parent_home_view.dart';
import 'package:yallado/features/parents/views/task_view.dart';

class ParentBottomNavigationBar extends StatefulWidget {
  const ParentBottomNavigationBar({super.key});

  @override
  State<ParentBottomNavigationBar> createState() =>
      _ParentBottomNavigationBarState();
}

class _ParentBottomNavigationBarState
    extends State<ParentBottomNavigationBar> {
  int currentIndex = 2;
  static const int _notifIndex = 3;
  static const int _tasksIndex = 0;
  // Bumped each time the Tasks tab is opened so it rebuilds and reloads — this
  // way a task created elsewhere (e.g. the Home button) shows up immediately.
  int _tasksReloadKey = 0;

  @override
  void initState() {
    super.initState();
    NotificationBadge.refresh();
  }

  List<Widget> get pages => [
        ParentTasksView(key: ValueKey('tasks_$_tasksReloadKey')),
        const AddRewardScreen(),
        const ParentHomeScreen(),
        const ParentNotificationsView(),
      ];

  final List<IconData> icons = [
    Icons.checklist_outlined,
    Icons.emoji_events_rounded,
    Icons.face,
    Icons.notifications_rounded,
  ];

  final List<String> labels = [
    "Tasks",
    "Rewards",
    "Home",
    "Notifications",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabScope(
        goHome: () => setState(() => currentIndex = 2),
        child: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          border: Border.all(
            color: AppColor.secondary,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
            ),
          ],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(icons.length, (index) {
            bool isSelected = currentIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  // Reload the Tasks tab each time it's opened so newly created
                  // tasks appear without a manual pull-to-refresh.
                  if (index == _tasksIndex) _tasksReloadKey++;
                  currentIndex = index;
                });
                // Refresh the badge whenever tabs change (e.g. after reading).
                NotificationBadge.refresh();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: NotificationBadge.unread,
                    builder: (context, count, child) => Badge(
                      isLabelVisible: index == _notifIndex && count > 0,
                      label: Text('$count'),
                      child: child,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColor.secondary
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icons[index],
                        color: isSelected
                            ? Colors.white
                            : AppColor.secondary,
                      ),
                    ),
                  ),
                  Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? AppColor.secondary
                          : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}