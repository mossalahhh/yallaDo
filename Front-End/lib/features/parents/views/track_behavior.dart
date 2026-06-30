import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/core/widgets/app_error_retry.dart';
import 'package:yallado/core/widgets/app_refresh.dart';
import 'package:yallado/features/parents/cubit/analytics_cubit/analytics_cubit.dart';

/// Parent behaviour analytics — shows ALL of this parent's children at once
/// (no "Choose Child" selector):
///  * per-child task progress %  (parent/progress-completion)
///  * points over time           (parent/analytics-points?range=)
///  * completion rate by category(parent/category-completion)
class TrackBehaviorView extends StatelessWidget {
  const TrackBehaviorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnalyticsCubit()..loadAll(),
      child: const _TrackBehaviorBody(),
    );
  }
}

class _TrackBehaviorBody extends StatelessWidget {
  const _TrackBehaviorBody();

  static const _periods = ['weekly', 'monthly', 'daily'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F0),
      body: SafeArea(
        child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
          builder: (context, state) {
            final cubit = context.read<AnalyticsCubit>();
            return AppRefresh(
              onRefresh: () => context.read<AnalyticsCubit>().loadAll(),
              child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      const Text('Track Behavior',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColor.secondary)),
                    ],
                  ),
                  if (state is AnalyticsLoading)
                    const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                          child: CircularProgressIndicator(
                              color: AppColor.secondary)),
                    )
                  else if (state is AnalyticsError)
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: AppErrorRetry(
                        message: state.message,
                        onRetry: () =>
                            context.read<AnalyticsCubit>().loadAll(),
                      ),
                    )
                  else ...[
                    const SizedBox(height: 8),
                    _sectionTitle("Children Progress (Approved %)"),
                    const SizedBox(height: 12),
                    if (cubit.progress.isEmpty)
                      _note("No children data yet")
                    else
                      ...cubit.progress.map((p) => _progressRow(
                          p.childName, p.approvedPercentage / 100,
                          "${p.approvedPercentage}%")),
                    const SizedBox(height: 24),
                    _sectionTitle("Points Over Time"),
                    const SizedBox(height: 10),
                    _periodTabs(context, cubit.range),
                    const SizedBox(height: 12),
                    _pointsCard(cubit),
                    const SizedBox(height: 24),
                    _sectionTitle("Completion by Category"),
                    const SizedBox(height: 12),
                    if (cubit.categories.isEmpty)
                      _note("No category data yet")
                    else
                      ...cubit.categories.map((c) => _progressRow(
                          c.category, c.completionRate / 100,
                          "${c.completionRate}%")),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ));
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t,
      style: const TextStyle(
          color: AppColor.secondary,
          fontWeight: FontWeight.w600,
          fontSize: 18));

  Widget _note(String t) =>
      Text(t, style: const TextStyle(color: Colors.grey));

  Widget _progressRow(String label, double value, String trailing) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppColor.secondary, fontWeight: FontWeight.w500)),
              Text(trailing,
                  style: const TextStyle(color: AppColor.secondary)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value.clamp(0.0, 1.0),
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              color: const Color(0xffcfe0c2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _periodTabs(BuildContext context, String current) {
    return Row(
      children: _periods.map((p) {
        final selected = p == current;
        return Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () => context.read<AnalyticsCubit>().setRange(p),
            child: Container(
              padding: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selected ? AppColor.secondary : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                p[0].toUpperCase() + p.substring(1),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: selected ? AppColor.secondary : Colors.grey,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _pointsCard(AnalyticsCubit cubit) {
    final pts = cubit.points;
    if (pts.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: const Text("No points activity in this range",
            style: TextStyle(color: Colors.grey)),
      );
    }
    final maxPts =
        pts.map((e) => e.points).fold<int>(1, (a, b) => b > a ? b : a);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 160,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: pts.map((p) {
            final h = (p.points / maxPts).clamp(0.05, 1.0) * 120;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("${p.points}",
                    style: const TextStyle(
                        fontSize: 11, color: AppColor.secondary)),
                const SizedBox(height: 4),
                Container(
                  width: 22,
                  height: h,
                  decoration: BoxDecoration(
                    color: const Color(0xffcfe0c2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 40,
                  child: Text(p.date,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10, color: Colors.grey)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
