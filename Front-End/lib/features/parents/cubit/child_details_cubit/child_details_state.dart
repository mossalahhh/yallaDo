import 'package:yallado/features/parents/data/models/child_model.dart';

abstract class ChildDetailsState {}

class ChildDetailsInitial extends ChildDetailsState {}

class ChildDetailsLoading extends ChildDetailsState {}

class ChildDetailsLoaded extends ChildDetailsState {
  final ChildDetails details;
  ChildDetailsLoaded(this.details);
}

class ChildDetailsError extends ChildDetailsState {
  final String message;
  ChildDetailsError(this.message);
}

class PointsAdjusting extends ChildDetailsState {}

class PointsAdjusted extends ChildDetailsState {
  final String message;
  PointsAdjusted(this.message);
}

class PointsAdjustError extends ChildDetailsState {
  final String message;
  PointsAdjustError(this.message);
}
