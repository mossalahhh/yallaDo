import 'package:flutter/material.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/features/notifications/data/notification_service.dart';
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
  int _notifCount = 0;
  static const int _notifIndex = 3;

  @override
  void initState() {
    super.initState();
    _loadNotifCount();
  }

  Future<void> _loadNotifCount() async {
    final res = await NotificationService().count();
    final c = (res.status && res.data is Map) ? res.data['count'] : null;
    if (mounted && c is num) setState(() => _notifCount = c.toInt());
  }

  final List<Widget> pages = const [
    ParentTasksView(),
    AddRewardScreen(),
    ParentHomeScreen(),
    ParentNotificationsView(),
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
      body: IndexedStack(
        index: currentIndex,
        children: pages,
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
                  currentIndex = index;
                });
                // Refresh the badge whenever tabs change (e.g. after reading).
                _loadNotifCount();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Badge(
                    isLabelVisible: index == _notifIndex && _notifCount > 0,
                    label: Text('$_notifCount'),
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