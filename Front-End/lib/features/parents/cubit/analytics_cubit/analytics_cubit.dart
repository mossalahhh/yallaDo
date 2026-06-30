import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/features/parents/data/models/analytics_model.dart';
import 'package:yallado/features/parents/data/parent_service.dart';

abstract class AnalyticsState {}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  AnalyticsLoaded();
}

class AnalyticsError extends AnalyticsState {
  final String message;
  AnalyticsError(this.message);
}

/// Loads the parent's behaviour analytics: per-child progress %, category
/// completion rates, and points-over-time. Used by the home progress card and
/// the Track-Behavior screen.
class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit() : super(AnalyticsInitial());

  final ParentService _service = ParentService();

  List<ChildProgress> progress = [];
  List<CategoryCompletion> categories = [];
  List<PointsPoint> points = [];
  String range = 'weekly';

  Future<void> loadAll() async {
    emit(AnalyticsLoading());
    final progressRes = await _service.getProgressCompletion();
    final categoryRes = await _service.getCategoryCompletion();
    final pointsRes = await _service.getPointsAnalytics(range);

    if (progressRes.status && progressRes.data is Map) {
      progress = ((progressRes.data['data'] as List?) ?? [])
          .map((e) => ChildProgress.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    }
    if (categoryRes.status && categoryRes.data is Map) {
      categories = ((categoryRes.data['stats'] as List?) ?? [])
          .map((e) =>
              CategoryCompletion.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    }
    if (pointsRes.status && pointsRes.data is Map) {
      points = ((pointsRes.data['results'] as List?) ?? [])
          .map((e) => PointsPoint.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    }

    if (!progressRes.status && !categoryRes.status) {
      emit(AnalyticsError(progressRes.message.isNotEmpty
          ? progressRes.message
          : 'Failed to load analytics'));
    } else {
      emit(AnalyticsLoaded());
    }
  }

  Future<void> setRange(String r) async {
    range = r;
    final pointsRes = await _service.getPointsAnalytics(range);
    if (pointsRes.status && pointsRes.data is Map) {
      points = ((pointsRes.data['results'] as List?) ?? [])
          .map((e) => PointsPoint.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    }
    emit(AnalyticsLoaded());
  }
}
