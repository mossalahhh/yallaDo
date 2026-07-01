import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/features/notifications/cubit/notifications_cubit.dart';
import 'package:yallado/features/notifications/notification_router.dart';

class ChildNotificationView extends StatelessWidget {
  const ChildNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit()..load(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F7F0),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [AppColor.white, AppColor.primary],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Row(
                    children: [
                      const Text("New 🔔",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColor.secondary)),
                      const Spacer(),
                      Builder(
                        builder: (context) => PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert,
                              color: AppColor.secondary),
                          onSelected: (v) {
                            final cubit = context.read<NotificationsCubit>();
                            if (v == 'read') cubit.readAll();
                            if (v == 'clear') cubit.deleteAll();
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                                value: 'read', child: Text("Mark all as read")),
                            PopupMenuItem(
                                value: 'clear', child: Text("Clear all")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<NotificationsCubit, NotificationsState>(
                    builder: (context, state) {
                      if (state is NotificationsLoading ||
                          state is NotificationsInitial) {
                        return const Center(
                            child: CircularProgressIndicator(
                                color: AppColor.secondary));
                      }
                      final items =
                          context.read<NotificationsCubit>().notifications;
                      if (items.isEmpty) {
                        return _empty(context,
                            state is NotificationsError
                                ? state.message
                                : "No notifications yet");
                      }
                      return RefreshIndicator(
                        onRefresh: () =>
                            context.read<NotificationsCubit>().load(),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, i) {
                            final n = items[i];
                            return Dismissible(
                              key: ValueKey(n.id.isNotEmpty ? n.id : i),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                color: Colors.red.shade100,
                                child:
                                    const Icon(Icons.delete, color: Colors.red),
                              ),
                              onDismissed: (_) => context
                                  .read<NotificationsCubit>()
                                  .deleteOne(n.id),
                              child: ListTile(
                                tileColor: n.isRead
                                    ? Colors.white
                                    : const Color(0xFFEFF6E8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                leading: const CircleAvatar(
                                  backgroundColor: AppColor.primary,
                                  child: Icon(Icons.star,
                                      color: AppColor.secondary),
                                ),
                                title: Text(n.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.secondary)),
                                subtitle: Text(n.message),
                                trailing: n.isRead
                                    ? null
                                    : const Icon(Icons.circle,
                                        size: 10, color: AppColor.secondary),
                                onTap: () {
                                  context
                                      .read<NotificationsCubit>()
                                      .readOne(n.id);
                                  final dest =
                                      childNotificationDestination(n);
                                  if (dest != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => dest),
                                    );
                                  }
                                },
                              ),
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

  Widget _empty(BuildContext context, String message) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 140),
        Icon(
          Icons.notifications_none_rounded,
          size: 96,
          color: AppColor.secondary.withValues(alpha: 0.35),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 15)),
        ),
      ],
    );
  }
}
