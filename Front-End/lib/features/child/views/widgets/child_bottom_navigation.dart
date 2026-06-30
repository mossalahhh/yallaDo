import 'package:flutter/material.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/core/widgets/tab_scope.dart';
import 'package:yallado/features/child/views/child_home_view.dart';
import 'package:yallado/features/child/views/child_notification_view.dart';
import 'package:yallado/features/child/views/child_tasks_view.dart';
import 'package:yallado/features/child/views/profile.dart';
import 'package:yallado/features/child/views/widgets/link_code_dialog.dart';
import 'package:yallado/features/notifications/data/notification_service.dart';
import 'package:yallado/features/user/data/user_service.dart';
class ChildBottomNavigationBar extends StatefulWidget {
  const ChildBottomNavigationBar({super.key});

  @override
  State<ChildBottomNavigationBar> createState() => _ChildBottomNavigationBarState();
}

class _ChildBottomNavigationBarState extends State<ChildBottomNavigationBar> {
  int currentIndex = 0;
  int _notifCount = 0;
  static const int _notifIndex = 3;

  @override
  void initState() {
    super.initState();
    _checkFamilyLink();
    _loadNotifCount();
  }

  Future<void> _loadNotifCount() async {
    final res = await NotificationService().count();
    final c = (res.status && res.data is Map) ? res.data['count'] : null;
    if (mounted && c is num) setState(() => _notifCount = c.toInt());
  }

  /// If the child isn't linked to any family yet, prompt for the family code
  /// right here instead of making them dig into Settings.
  Future<void> _checkFamilyLink() async {
    final res = await UserService().getProfile();
    final profile = (res.data is Map) ? res.data['profile'] : null;
    final parents = (profile is Map) ? profile['parentNames'] : null;
    final linked = parents is List && parents.isNotEmpty;
    if (!linked && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showLinkCodeDialog(context);
      });
    }
  }

  final List<Widget> pages = [
    ChildHomeView(),
    ProfileScreenChild(),
    ChildTasksView(),
    ChildNotificationView(),
  ];
  final List<IconData> icons = [
    Icons.home_rounded,
    Icons.person_rounded,
    Icons.task,
    Icons.notifications_rounded,

  ];

  final List<String> labels = [
    "Home",
    "Profile",
    "Tasks",
    "Notification",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F7F0),
      extendBody: true,
      body: TabScope(
        goHome: () => setState(() => currentIndex = 0),
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
                  currentIndex = index;
                });
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




