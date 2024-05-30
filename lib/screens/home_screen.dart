import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pomo_nomad/constants/gaps.dart';
import 'package:pomo_nomad/constants/sizes.dart';
import 'package:pomo_nomad/widgets/score_board.dart';
import 'package:pomo_nomad/widgets/selected_button.dart';

final selectTime = [10, 15, 20, 25, 30, 35];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 1500;
  int totalSeconds = twentyFiveMinutes;
  bool isRunning = false;
  bool isBreakTime = false; // 새로운 상태 변수 추가
  late Timer timer;
  late int selectedTime;
  int totalRound = 0, totalGoal = 0;

  @override
  void initState() {
    super.initState();
    selectedTime = totalSeconds;
  }

  void _onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        totalSeconds = selectedTime;
        totalRound++;
        isRunning = false;
        isBreakTime = true; // Break time 시작
        if (totalRound == 4) {
          totalRound = 0;
          totalGoal++;
        }
      });
      timer.cancel();
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          isBreakTime = false; // Break time 종료
        });
      });
    } else {
      setState(() {
        totalSeconds--;
      });
    }
  }

  void _onStartPressed() {
    if (isBreakTime) return; // Break time 동안 시작 버튼 무시
    timer = Timer.periodic(
      const Duration(milliseconds: 1),
      _onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  void _onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void _onResetPressed() {
    setState(() {
      totalSeconds = selectedTime;
      isRunning = false;
      isBreakTime = false; // 리셋 시 Break time 종료
    });
    timer.cancel();
  }

  void _onTimeSelected(int seconds) {
    setState(() {
      totalSeconds = seconds;
      selectedTime = seconds;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split('.').first.substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        backgroundColor: Colors.amber[50],
        elevation: 0,
        title: const Text(
          "POMOTIMER",
          style: TextStyle(
            fontSize: Sizes.size20,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Gaps.v96,
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Text(
              format(totalSeconds),
              style: const TextStyle(
                fontSize: Sizes.size80 + Sizes.size20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: SizedBox(
              height: Sizes.size60,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size20),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var time in selectTime)
                      SelectedButton(
                        time: time,
                        onSelected: _onTimeSelected,
                      ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: isBreakTime
                ? IconButton(
                    iconSize: Sizes.size80,
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.trophy,
                    ),
                  )
                : IconButton(
                    iconSize: Sizes.size80 + Sizes.size20,
                    onPressed: isRunning ? _onPausePressed : _onStartPressed,
                    icon: Icon(
                      isRunning
                          ? Icons.pause_circle_filled_outlined
                          : Icons.play_circle_outline,
                    ),
                  ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: isBreakTime
                ? const Column(
                    children: [
                      Text(
                        "Break Time!",
                        style: TextStyle(
                          fontSize: Sizes.size28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gaps.v16,
                      Text(
                        "Proud of You!!",
                        style: TextStyle(
                          fontSize: Sizes.size28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : AnimatedOpacity(
                    duration: const Duration(milliseconds: 700),
                    opacity: isRunning ? 1.0 : 0.0,
                    child: isRunning
                        ? IconButton(
                            color: const Color(0xFF232B55),
                            iconSize: 40,
                            onPressed: _onResetPressed,
                            icon:
                                const FaIcon(FontAwesomeIcons.arrowRotateRight),
                          )
                        : const SizedBox(),
                  ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size20,
                vertical: Sizes.size20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ScoreBoard(
                    countScore: totalRound,
                    maxScore: 4,
                    text: "Round",
                  ),
                  const Text(
                    "|",
                    style: TextStyle(
                      fontSize: Sizes.size64,
                      color: Color(0xFF232B55),
                    ),
                  ),
                  ScoreBoard(
                    countScore: totalGoal,
                    text: "Goal",
                    maxScore: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
