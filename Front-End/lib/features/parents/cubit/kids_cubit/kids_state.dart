import 'package:yallado/features/parents/data/model/kid_model.dart';

abstract class KidsState {}

class KidsInitial extends KidsState {}

class KidsLoaded extends KidsState {
  final List<KidModel> kids;

  KidsLoaded(this.kids);
}