import 'package:flutter/material.dart';
import 'package:gym_tracker/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'landing.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isLoading = true;
  bool showHome = false;

  void initialization() async{
    SharedPreferences isSeen = await SharedPreferences.getInstance();
    if(isSeen.getBool("seen") == true){
      setState(() {
        showHome = true;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    if(showHome){
      return const Home();
    }
    else if(!showHome){
      return const Landing();
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
