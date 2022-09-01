import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/noti/noti_api.dart';
import 'package:gym_tracker/screens/splash.dart';
import 'package:gym_tracker/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotiApi.init(initSchedule: true);
  runApp(
    EasyDynamicThemeWidget(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;
    return DynamicColorBuilder(
      builder: (ColorScheme? dayColorScheme,
      ColorScheme? nightColorScheme){
        return MaterialApp(
          title: 'Gym Tracker',
          darkTheme: AppTheme.nightTheme(nightColorScheme),
          theme: isDarkModeOn ? AppTheme.nightTheme(nightColorScheme)
              : AppTheme.dayTheme(dayColorScheme),
          themeMode: EasyDynamicTheme.of(context).themeMode,
          home: const Splash(),
        );
      },
    );
  }
}
