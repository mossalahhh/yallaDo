import 'package:yallado/features/parents/data/models/child_model.dart';

abstract class ChildrenState {}

class ChildrenInitial extends ChildrenState {}

class ChildrenLoading extends ChildrenState {}

class ChildrenLoaded extends ChildrenState {
  final List<ChildSummary> children;
  ChildrenLoaded(this.children);
}

class ChildrenError extends ChildrenState {
  final String message;
  ChildrenError(this.message);
}

class ChildActionLoading extends ChildrenState {}

class ChildUnlinked extends ChildrenState {
  final String message;
  ChildUnlinked(this.message);
}

class ChildActionError extends ChildrenState {
  final String message;
  ChildActionError(this.message);
}
