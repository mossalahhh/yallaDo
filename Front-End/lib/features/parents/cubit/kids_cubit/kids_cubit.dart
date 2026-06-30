import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/features/parents/data/model/kid_model.dart';
import 'kids_state.dart';

class KidsCubit extends Cubit<KidsState> {
  KidsCubit() : super(KidsInitial());

  final List<KidModel> kids = [];

  void addKid(KidModel kid) {
    kids.add(kid);
    emit(KidsLoaded(List.from(kids)));
  }
}