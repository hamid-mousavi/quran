import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran_app/features/plan/data/Molel/plan.dart';

part 'plan_event.dart';
part 'plan_state.dart';


// Bloc
class PlanBloc extends Bloc<PlanEvent, PlanState> {
  PlanBloc() : super(PlanLoading()) {
    on<LoadPlansEvent>((event, emit) {
      emit(PlanLoaded(plans: [
        Plan(date: "۱۴ مهر", ayahCount: 5),
        Plan(date: "۱۵ مهر", ayahCount: 3),
      ]));
    });
  }
}


