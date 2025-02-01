part of 'plan_bloc.dart';

@immutable
// State
abstract class PlanState {}
class PlanLoading extends PlanState {}
class PlanLoaded extends PlanState {
  final List<Plan> plans;
  PlanLoaded({required this.plans});
}