import 'package:yallado/features/parents/data/models/child_model.dart';

abstract class ChildHistoryState {}

class ChildHistoryInitial extends ChildHistoryState {}

class ChildHistoryLoading extends ChildHistoryState {}

class ChildHistoryLoaded extends ChildHistoryState {
  final List<HistoryEntry> entries;
  ChildHistoryLoaded(this.entries);
}

class ChildHistoryError extends ChildHistoryState {
  final String message;
  ChildHistoryError(this.message);
}
