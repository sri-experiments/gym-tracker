import 'package:flutter/material.dart';
import 'package:gym_tracker/db/workouts_model.dart';

import '../common_widgets/workout_details.dart';
import '../db/db_helper.dart';

class Workouts extends StatefulWidget {
  final String workoutName;
  const Workouts(this.workoutName, {Key? key}) : super(key: key);

  @override
  State<Workouts> createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(widget.workoutName),
        ),
        body: FutureBuilder<List<WorkoutModels>>(
          future: DatabaseHelper.instance.getWorkout(widget.workoutName),
          builder: (BuildContext context,
              AsyncSnapshot<List<WorkoutModels>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return snapshot.data!.isEmpty
                ? const Center(child: Text('No Workout'))
                : ListView(
              children: snapshot.data!.map((workout) {
                return WorkoutDetails(
                  workout.workoutName,
                  workout.workoutCategory,
                  workout.id!,
                  workout.weightLifted,
                  workout.reps,
                  workout.sets,
                  workout.workoutDate,
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
