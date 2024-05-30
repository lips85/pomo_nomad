import 'package:flutter/material.dart';
import 'package:pomo_nomad/screens/home_screen.dart';

void main() {
  runApp(const HaruPomodoro());
}

class HaruPomodoro extends StatelessWidget {
  const HaruPomodoro({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haru Pomodoro',
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.amber[50],
      ),
      home: const HomeScreen(),
    );
  }
}
