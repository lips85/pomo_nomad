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
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.amber,
        ).copyWith(
          secondary: const Color(0xFF232B55),
          onPrimary: const Color(0xFF232B55),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Color(0xFF232B55)),
          bodyLarge: TextStyle(color: Color(0xFF232B55)),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
