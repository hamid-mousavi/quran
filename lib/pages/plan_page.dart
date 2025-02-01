import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/features/plan/data/Molel/plan.dart';
import 'package:quran_app/features/plan/logic/bloc/plan_bloc.dart';

class PlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlanBloc()..add(LoadPlansEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("برنامه‌ریزی حفظ", textAlign: TextAlign.center),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            _buildCalendar(),
            Expanded(child: _buildPlanList()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addNewPlan(context),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(
          "تقویم ماهانه اینجا"), // اینجا می‌توان از یک ویجت تقویم واقعی استفاده کرد
    );
  }

  Widget _buildPlanList() {
    return BlocBuilder<PlanBloc, PlanState>(
      builder: (context, state) {
        if (state is PlanLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PlanLoaded) {
          return ListView.builder(
            itemCount: state.plans.length,
            itemBuilder: (context, index) {
              final plan = state.plans[index];
              return ListTile(
                title: Text("${plan.date} - ${plan.ayahCount} آیه"),
                trailing: ElevatedButton(
                  onPressed: () {}, // اینجا می‌توان لاجیک شروع را اضافه کرد
                  child: Text("شروع"),
                ),
              );
            },
          );
        } else {
          return Center(child: Text("برنامه‌ای وجود ندارد"));
        }
      },
    );
  }

  void _addNewPlan(BuildContext context) {
    // لاجیک اضافه کردن برنامه جدید
  }
}
