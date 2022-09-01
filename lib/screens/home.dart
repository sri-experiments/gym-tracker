import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/screens/log_workout.dart';
import 'package:gym_tracker/screens/workouts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = "";

  void initialization() async{
    SharedPreferences userName = await SharedPreferences.getInstance();
    setState(() {
      name = userName.getString("name")!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    initialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Gym Tracker"),
          automaticallyImplyLeading: false,
          centerTitle: false,
          actions: [
            // user icon btn
            IconButton(
              onPressed: (){
                const infoSnackBar = SnackBar(
                    content: Text("Will be enabled later"),
                );
                ScaffoldMessenger.of(context).showSnackBar(infoSnackBar);
              },
              icon: ExcludeSemantics(
                child: CircleAvatar(
                  child: Text(name[0].toUpperCase()),
                ),
              ),
            ),
            IconButton(
              onPressed: (){
                setState(() {
                  if(isDarkModeOn){
                    isDarkModeOn = false;
                  }
                  else{
                    isDarkModeOn = true;
                  }
                  EasyDynamicTheme.of(context).changeTheme();
                });
              },
              icon: isDarkModeOn ? const Icon(Icons.dark_mode) :
              const Icon(Icons.light_mode),
            ),
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10),
          children: [
            Text("Welcome\n$name",
            style: Theme.of(context).textTheme.headline5,),
            const Divider(indent: 20, endIndent: 20,),
            Text("Workout's",
            style: Theme.of(context)
              .textTheme.headline6,),
            const SizedBox(height: 10,),
            workoutListTile("Arm Workout"),
            const Divider(indent: 20, endIndent: 20,),
            workoutListTile("Back Workout"),
            const Divider(indent: 20, endIndent: 20,),
            workoutListTile("Chest Workout"),
            const Divider(indent: 20, endIndent: 20,),
            workoutListTile("Leg Workout"),
            const Divider(indent: 20, endIndent: 20,),
            workoutListTile("Shoulder Workout"),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LogWorkout()));
          },
          tooltip: 'Log Workout',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget workoutListTile(String workoutName){
    return Card(
      child: ListTile(
        onTap: (){
          Navigator.of(context)
              .push(MaterialPageRoute(
              builder: (context) => Workouts(workoutName)
          ));
        },
        title: Text(workoutName),
      ),
    );
  }
}
