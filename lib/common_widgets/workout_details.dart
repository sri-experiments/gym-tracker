import 'package:flutter/material.dart';
import 'package:gym_tracker/screens/edit_workout.dart';
import 'package:intl/intl.dart';

class WorkoutDetails extends StatelessWidget {
  final String workoutName, workoutCategory;
  final int id, weightLifted, reps, sets;
  final DateTime workedOutOn;
  const WorkoutDetails(this.workoutName, this.workoutCategory,
      this.id, this.weightLifted, this.reps, this.sets,
      this.workedOutOn, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: (){
          showModalBottomSheet(
              context: context,
              builder: (context){
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Text("Workout Name"),
                      Text(workoutName),
                      const Divider(indent: 20, endIndent: 20,),
                      const Text("Weights Lifted"),
                      Text("${weightLifted.toString()} lbs"),
                      const Divider(indent: 20, endIndent: 20,),
                      const Text("Reps"),
                      Text(reps.toString()),
                      const Divider(indent: 20, endIndent: 20,),
                      const Text("Sets"),
                      Text(sets.toString()),
                      const Divider(indent: 20, endIndent: 20,),
                      ElevatedButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                              builder: (context) => EditWorkout(
                                workoutName,
                                workoutCategory,
                                id,
                                weightLifted,
                                reps,
                                sets,
                                workedOutOn,
                              )));
                        },
                        child: const Text("Edit Workout"),
                      ),
                    ],
                  ),
                );
              }
          );
        },
        title: Text(workoutName),
        subtitle: Text(
          "Last Exercised On: ${DateFormat.yMMMd().format(workedOutOn)}",
        ),
      ),
    );
  }
}
