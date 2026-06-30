import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_nav.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/core/widgets/tab_scope.dart';
import 'package:yallado/features/notifications/cubit/notifications_cubit.dart';

class ParentNotificationsView extends StatelessWidget {
  const ParentNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit()..load(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xff6C63FF)),
            onPressed: () => AppNav.back(context,
                fallback: () => TabScope.of(context)?.goHome()),
          ),
          title: const Text('Notifications',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
          centerTitle: true,
          actions: [
            Builder(
              builder: (context) => PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.black54),
                onSelected: (v) {
                  final cubit = context.read<NotificationsCubit>();
                  if (v == 'read') cubit.readAll();
                  if (v == 'clear') cubit.deleteAll();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'read', child: Text("Mark all as read")),
                  PopupMenuItem(value: 'clear', child: Text("Clear all")),
                ],
              ),
            ),
          ],
        ),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading || state is NotificationsInitial) {
              return const Center(
                  child: CircularProgressIndicator(color: AppColor.secondary));
            }
            if (state is NotificationsError) {
              return _empty(context, state.message);
            }
            final items = context.read<NotificationsCubit>().notifications;
            if (items.isEmpty) {
              return _empty(context, "No notifications yet");
            }
            return RefreshIndicator(
              onRefresh: () => context.read<NotificationsCubit>().load(),
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final n = items[i];
                  return Dismissible(
                    key: ValueKey(n.id.isNotEmpty ? n.id : i),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red.shade100,
                      child: const Icon(Icons.delete, color: Colors.red),
                    ),
                    onDismissed: (_) =>
                        context.read<NotificationsCubit>().deleteOne(n.id),
                    child: ListTile(
                      tileColor:
                          n.isRead ? Colors.white : const Color(0xFFEFF3FB),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      leading: CircleAvatar(
                        backgroundColor:
                            AppColor.primary.withValues(alpha: 0.5),
                        child: const Icon(Icons.notifications,
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
                              size: 10, color: Color(0xff6C63FF)),
                      onTap: () =>
                          context.read<NotificationsCubit>().readOne(n.id),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _empty(BuildContext context, String message) {
    return ListView(
      // ListView so RefreshIndicator/scroll works and the message centers
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 140),
        Icon(
          Icons.notifications_none_rounded,
          size: 96,
          color: AppColor.secondary.withValues(alpha: 0.35),
        ),
        const SizedBox(height: 24),
        Center(
          child: Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () => context.read<NotificationsCubit>().load(),
            child: const Text("Refresh"),
          ),
        ),
      ],
    );
  }
}
