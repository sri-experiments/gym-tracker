import 'package:flutter/material.dart';
import 'package:gym_tracker/db/db_helper.dart';
import 'package:gym_tracker/db/workouts_model.dart';
import 'package:gym_tracker/screens/home.dart';

class EditWorkout extends StatefulWidget {
  final String workoutName, workoutCategory;
  final int id, weightLifted, reps, sets;
  final DateTime workedOutOn;
  const EditWorkout(this.workoutName, this.workoutCategory,
      this.id, this.weightLifted, this.reps, this.sets,
      this.workedOutOn, {Key? key}) : super(key: key);

  @override
  State<EditWorkout> createState() => _EditWorkoutState();
}

class _EditWorkoutState extends State<EditWorkout> {
  TextEditingController workoutName = TextEditingController();
  TextEditingController weightLifted = TextEditingController();
  TextEditingController reps = TextEditingController();
  TextEditingController sets = TextEditingController();
  DateTime now = DateTime.now();
  DateTime selected = DateTime.now();
  bool isNewDateSelected = false;
  bool isLoading = true;

  void initialization() async{
    workoutName.text = widget.workoutName;
    weightLifted.text = widget.weightLifted.toString();
    reps.text = widget.reps.toString();
    sets.text = widget.sets.toString();
    now = widget.workedOutOn;
    isLoading = false;
  }
  
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Workout"),
          centerTitle: false,
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Home()));
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: isLoading ? const Center(
          child: CircularProgressIndicator(),
        ) : ListView(
          padding: const EdgeInsets.all(10),
          children: [
            TextFormField(
              controller: workoutName,
              decoration: const InputDecoration(
                label: Text("Workout Name"),
                hintText: 'Ex: Bicep Curls',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              autocorrect: true,
            ),
            const SizedBox(height: 10,),
            TextFormField(
              controller: weightLifted,
              decoration: const InputDecoration(
                label: Text("Weight Lifted"),
                hintText: 'Ex: 50-50-55',
                border: OutlineInputBorder(),
                suffixText: 'Lbs',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10,),
            TextFormField(
              controller: reps,
              decoration: const InputDecoration(
                label: Text("Reps"),
                hintText: 'Ex: 12-10-8',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10,),
            TextFormField(
              controller: sets,
              decoration: const InputDecoration(
                label: Text("Sets"),
                hintText: 'Ex: 3',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10,),
            Card(
              child: ListTile(
                onTap: () async{
                  setState((){
                    isNewDateSelected = false;
                  });
                  DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: now,
                      lastDate: DateTime(2050)
                  );
                  if(picked != null
                      && picked != now){
                    setState((){
                      selected = picked;
                      isNewDateSelected = true;
                    });
                  }
                },
                title: isNewDateSelected ?
                Text("${selected.month}/${selected.day}/${selected.year}") :
                Text("${now.month}/${now.day}/${now.year}"),
              ),
            ),
            ElevatedButton(
              onPressed: () async{
                if(workoutName.text.trim().isEmpty
                    || weightLifted.text.trim().isEmpty
                    || reps.text.trim().isEmpty
                    || sets.text.trim().isEmpty){
                  const snackBar = SnackBar(
                    content: Text("All fields are required"),
                    backgroundColor: Colors.red,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                else{
                  final wm = WorkoutModels(
                    id: widget.id,
                    workoutCategory: widget.workoutCategory,
                    workoutName: widget.workoutName,
                    weightLifted: int.parse(weightLifted.text),
                    reps: int.parse(reps.text),
                    sets: int.parse(sets.text),
                    workoutDate: selected,
                  );
                  await DatabaseHelper.instance
                  .update(wm);
                  afterUpdate();
                }
              },
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }

  void afterUpdate(){
    const snackBar = SnackBar(content: Text("Update Successful"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const Home()));
  }
}
