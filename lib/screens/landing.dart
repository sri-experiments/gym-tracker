import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gym_tracker/noti/noti_api.dart';
import 'package:gym_tracker/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  TextEditingController name = TextEditingController();
  TimeOfDay workoutReminder = const TimeOfDay(hour: 17, minute: 00);
  TimeOfDay logWorkout = const TimeOfDay(hour: 18, minute: 00);
  bool isLoading = true;
  bool isNotiPermissionGranted = false;
  String weightMetrics = "Lbs";
  void initialization() async{
    bool? result = await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();

    setState((){
      isNotiPermissionGranted = result!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialization();
  }

  void _selectAndroidTime(String reminderName) async{
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: reminderName == "workout" ? workoutReminder : logWorkout,
    );
    if (newTime != null) {
      if(reminderName == "workout"){
        setState(() {
          workoutReminder = TimeOfDay(hour: newTime.hour, minute: newTime.minute);
        });
      }
      else{
        setState(() {
          logWorkout = TimeOfDay(hour: newTime.hour, minute: newTime.minute);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(10),
          shrinkWrap: true,
          children: [
            Text("Setup",
            style: Theme.of(context).textTheme.headline5,),
            const SizedBox(height: 10,),
            TextFormField(
              controller: name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Name"),
              ),
              autofillHints: const [AutofillHints.name],
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 10,),
            Text("Reminders",
            style: Theme.of(context).textTheme.headline6,),
            Card(
              child: ListTile(
                onTap: (){
                  _selectAndroidTime("workout");
                },
                title: const Text("Workout Reminder"),
                subtitle: Text(workoutReminder.format(context),),
                trailing: const Icon(Icons.edit),
              ),
            ),
            Card(
              child: ListTile(
                onTap: (){
                  _selectAndroidTime("log");
                },
                title: const Text("Log Workout Reminder"),
                subtitle: Text(logWorkout.format(context),),
                trailing: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 10,),
            Text("What metrics do you want to use",
              style: Theme.of(context).textTheme.headline6,),
            Wrap(
              runSpacing: 5,
              spacing: 5,
              children: [
                ChoiceChip(
                  onSelected: (selected){
                    setState(() {
                      weightMetrics = "Lbs";
                    });
                  },
                  label: const Text("Lbs"),
                  selected: weightMetrics == "Lbs",
                ),
                ChoiceChip(
                  onSelected: (selected){
                    setState(() {
                      weightMetrics = "Kgs";
                    });
                  },
                  label: const Text("Kgs"),
                  selected: weightMetrics == "Kgs",
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async{
                if(name.text.isEmpty){
                  const errorSnackBar = SnackBar(
                      content: Text("Name is required"),
                    backgroundColor: Colors.red,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
                }
                else{
                  NotiApi.scheduleWorkoutReminder(
                    title: "Workout Time",
                    body: "Time to leave, don't forget your water bottle",
                    payLoad: "workout",
                    hr: workoutReminder.hour,
                    min: workoutReminder.minute,
                  );
                  NotiApi.scheduleLogWorkout(
                    title: "Log Workout",
                    body: "It's time to log your workout",
                    payLoad: "log workout",
                    hr: logWorkout.hour,
                    min: logWorkout.minute,
                  );
                  SharedPreferences userName = await SharedPreferences.getInstance();
                  await userName.setString("name", name.text);
                  SharedPreferences workoutHr = await SharedPreferences.getInstance();
                  SharedPreferences workoutMin = await SharedPreferences.getInstance();
                  SharedPreferences logHr = await SharedPreferences.getInstance();
                  SharedPreferences logMin = await SharedPreferences.getInstance();
                  SharedPreferences isSeen = await SharedPreferences.getInstance();
                  SharedPreferences metrics = await SharedPreferences.getInstance();
                  await workoutHr.setInt("wHr", workoutReminder.hour);
                  await workoutMin.setInt("wMin", workoutReminder.minute);
                  await logHr.setInt("lHr", logWorkout.hour);
                  await logMin.setInt("lMin", logWorkout.minute);
                  await isSeen.setBool("seen", true);
                  await metrics.setString('userMetrics', weightMetrics);
                  navigate();
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  void navigate(){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const Home()));
  }
}
