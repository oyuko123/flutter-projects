import 'package:master_plan/plan_provider.dart';

import '../models/data_layer.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  final Plan plan;
  const PlanScreen({super.key, required this.plan});
  @override
  State createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late ScrollController scrollController;

  
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        FocusScope.of(context).requestFocus(FocusNode());
      });
  }

  
  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Plan>> plansNotifier = PlanProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.plan.name)),
      body: ValueListenableBuilder<List<Plan>>(
        valueListenable: plansNotifier,
        builder: (context, plans, child) {
          Plan currentPlan = plans.firstWhere(
            (p) => p.name == widget.plan.name,
          );
          return Column(
            children: [
              Expanded(child: _buildList(currentPlan)),
              SafeArea(
                child: Text(
                  currentPlan.completenessMessage,
                  style: TextStyle(
                    decoration: currentPlan.isComplete ? TextDecoration.lineThrough : TextDecoration.none,
                    decorationColor: Colors.black,  
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _buildAddTaskButton(context),
    );
  }

  Widget _buildAddTaskButton(BuildContext context) {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        //notifier damjuulj odoogiin plan avna
        Plan currentPlan = planNotifier.value.firstWhere(
          (p) => p.name == widget.plan.name,
          orElse: () => widget.plan,
        );
        
        // Shine task uusgene
        final newTask = const Task();
        
        // shine task nemegdsen taskiin list uusgene
        final updatedTasks = [...currentPlan.tasks, newTask];
        
        // Odoogiin planii indexiig olno
        final planIndex = planNotifier.value.indexWhere(
          (p) => p.name == currentPlan.name,
        );
        
        // Task nemej shinechilsen plantai list uusgene
        final updatedPlans = List<Plan>.from(planNotifier.value);
        updatedPlans[planIndex] = Plan(
          name: currentPlan.name,
          tasks: updatedTasks,
        );
        
        // notifier g shinechillene
        planNotifier.value = updatedPlans;
      },
    );
  }

  Widget _buildList(Plan plan) {
    return ListView.builder(
      controller: scrollController,
      itemCount: plan.tasks.length,
      itemBuilder: (context, index) =>
          _buildTaskTile(plan.tasks[index], index, context),
    );
  }

  Widget _buildTaskTile(Task task, int index, BuildContext context) {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
    
    // Notifier damjuulj odoogiin plan avna
    Plan currentPlan = planNotifier.value.firstWhere(
      (p) => p.name == widget.plan.name,
      orElse: () => widget.plan,
    );

    return ListTile(
      leading: Checkbox(
        value: task.complete,
        onChanged: (selected) {
          if (selected == null) return;
          
          // Odoogiin plan indexiig olno
          final planIndex = planNotifier.value.indexWhere(
            (p) => p.name == currentPlan.name,
          );
          if (planIndex == -1) return;

          // Shineer uusgesen tasktai list uusgene
          final updatedTasks = List<Task>.from(currentPlan.tasks);
          updatedTasks[index] = Task(
            description: task.description,
            complete: selected,
          );

          // Shineer tasktai bolson plantai list uusgene
          final updatedPlans = List<Plan>.from(planNotifier.value);
          updatedPlans[planIndex] = Plan(
            name: currentPlan.name,
            tasks: updatedTasks,
          );

          // notifier g shinechillene
          planNotifier.value = updatedPlans;
        },
      ),
      title: TextFormField(
        initialValue: task.description,
        style: TextStyle(
          decoration: task.complete ? TextDecoration.lineThrough : TextDecoration.none,
        ),
        onChanged: (text) {
          final planIndex = planNotifier.value.indexWhere(
            (p) => p.name == currentPlan.name,
          );
          if (planIndex == -1) return;

          final updatedTasks = List<Task>.from(currentPlan.tasks);
          updatedTasks[index] = Task(
            description: text,
            complete: task.complete,
          );

          final updatedPlans = List<Plan>.from(planNotifier.value);
          updatedPlans[planIndex] = Plan(
            name: currentPlan.name,
            tasks: updatedTasks,
          );

          planNotifier.value = updatedPlans;
        },
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
