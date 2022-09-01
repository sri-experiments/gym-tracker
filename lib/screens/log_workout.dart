import 'package:flutter/material.dart';
import 'package:gym_tracker/db/workouts_model.dart';
import 'package:gym_tracker/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/db_helper.dart';

class LogWorkout extends StatefulWidget {
  const LogWorkout({Key? key}) : super(key: key);

  @override
  State<LogWorkout> createState() => _LogWorkoutState();
}

class _LogWorkoutState extends State<LogWorkout> {
  static const List<String> _workoutOptions = <String>[
    'Arm Workout',
    'Back Workout',
    'Chest Workout',
    'Leg Workout',
    'Shoulder Workout',
  ];
  String selectedWorkout = '';
  TextEditingController? workoutName, weightLifted, reps, sets;
  DateTime now = DateTime.now();
  DateTime selected = DateTime.now();
  bool isNewDateSelected = false;
  bool isLoading = true;
  String weightMetrics = "";

  void initializer() async{
    SharedPreferences metrics = await SharedPreferences.getInstance();
    setState(() {
      weightMetrics = metrics.getString("userMetrics")!;
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    workoutName = TextEditingController();
    weightLifted = TextEditingController();
    reps = TextEditingController();
    sets = TextEditingController();
    initializer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: isLoading ? const Center(
          child: CircularProgressIndicator(),
        ) : ListView(
          padding: const EdgeInsets.all(10),
          children: [
            RawAutocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return _workoutOptions.where((String option) {
                  return option.contains(textEditingValue.text);
                });
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Workout Category"),
                  ),
                  onFieldSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                  textCapitalization: TextCapitalization.words,
                  autocorrect: true,
                );
              },
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<String> onSelected,
                  Iterable<String> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: SizedBox(
                      height: 200.0,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return ListTile(
                            onTap: (){
                              onSelected(option);
                              setState((){
                                selectedWorkout = option;
                              });
                            },
                            title: Text(option),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10,),
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
              decoration: InputDecoration(
                label: const Text("Weight Lifted"),
                hintText: 'Ex: 50',
                border: const OutlineInputBorder(),
                suffixText: weightMetrics,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10,),
            TextFormField(
              controller: reps,
              decoration: const InputDecoration(
                label: Text("Reps"),
                hintText: 'Ex: 12',
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
                if(selectedWorkout == ''
                    || workoutName!.text.isEmpty
                    || weightLifted!.text.isEmpty
                    || reps!.text.isEmpty
                    || sets!.text.isEmpty){
                  const successSnackBar = SnackBar(
                    content: Text("All fields are required"),
                    backgroundColor: Colors.red,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
                }
                else{
                  await DatabaseHelper.instance.add(
                    WorkoutModels(
                      workoutCategory: selectedWorkout,
                      workoutName: workoutName!.text,
                      weightLifted: int.parse(weightLifted!.text),
                      reps: int.parse(reps!.text),
                      sets: int.parse(sets!.text),
                      workoutDate: selected,
                    ),
                  );
                  afterSave();
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  void afterSave(){
    const successSnackBar = SnackBar(content: Text("Workout Saved"));
    ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const Home()));
  }
}
