import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomo_nomad/constants/gaps.dart';
import 'package:pomo_nomad/constants/sizes.dart';
import 'package:pomo_nomad/widgets/score_board.dart';

final select_time = [5, 10, 15, 20, 25, 30];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 1500;
  int totalSeconds = twentyFiveMinutes;
  bool isRunning = false;
  bool isReset = false;
  late Timer timer;
  int totalPomodoros = 0;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        totalSeconds = twentyFiveMinutes;
        totalPomodoros = totalPomodoros + 1;
        isRunning = false;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onResetPressed() {
    setState(() {
      totalSeconds = twentyFiveMinutes;
      isRunning = false;
    });
    timer.cancel();
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split('.').first.substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size20,
            vertical: Sizes.size40,
          ),
          child: Column(
            children: [
              Gaps.v96,
              Text(
                format(totalSeconds),
                style: TextStyle(
                  color: Colors.amber[50],
                  fontSize: Sizes.size80 + Sizes.size20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.v20,
              SizedBox(
                height: Sizes.size60, // 높이 설정
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: select_time.map((time) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.size20,
                          vertical: Sizes.size10,
                        ),
                        margin: const EdgeInsets.only(right: 20), // 요소 사이 간격 설정
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            time.toString(),
                            style: TextStyle(
                              color: Colors.amber[50],
                              fontSize: Sizes.size20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Gaps.v96,
              IconButton(
                iconSize: Sizes.size80 + Sizes.size20,
                color: Colors.amber[50],
                onPressed: isRunning ? onPausePressed : onStartPressed,
                icon: Icon(isRunning
                    ? Icons.pause_circle_filled_outlined
                    : Icons.play_circle_outline),
              ),
              Gaps.v10,
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: isRunning ? 1.0 : 0.0,
                child: IconButton(
                  iconSize: 40,
                  color: Colors.amber[50],
                  onPressed: onResetPressed,
                  icon: const Icon(Icons.restart_alt_outlined),
                ),
              ),
              Gaps.v72,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size20,
                  vertical: Sizes.size20,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ScoreBoard(
                      countScore: totalPomodoros,
                      maxScore: 4,
                      text: "Round",
                    ),
                    const Text(
                      "/",
                      style: TextStyle(
                        fontSize: 58,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF232B55),
                      ),
                    ),
                    ScoreBoard(
                      countScore: totalPomodoros,
                      text: "Goal",
                      maxScore: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
