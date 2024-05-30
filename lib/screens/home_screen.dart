import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomo_nomad/constants/gaps.dart';
import 'package:pomo_nomad/constants/sizes.dart';
import 'package:pomo_nomad/widgets/score_board.dart';
import 'package:pomo_nomad/widgets/time_button.dart';

final selectTime = [2, 15, 20, 25, 30, 35];

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
  late int selectedTime;
  int totalRound = 0, totalGoal = 0;

  void _onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        totalSeconds = selectedTime;
        totalRound = totalRound + 1;
        isRunning = false;

        if (totalRound == 4) {
          totalRound = 0;
          totalGoal = totalGoal + 1;
        }
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void _onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
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
    });
    timer.cancel();
  }

  void _onTimeSelected(int seconds) {
    setState(() {
      totalSeconds = seconds;
      selectedTime = totalSeconds;
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
        children: [
          Gaps.v96,
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Text(
              format(totalSeconds),
              style: const TextStyle(
                color: Colors.black,
                fontSize: Sizes.size80 + Sizes.size20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: SizedBox(
              height: Sizes.size60, // 높이 설정
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size20,
                ),
                clipBehavior: Clip.hardEdge,
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
            child: IconButton(
              iconSize: Sizes.size80 + Sizes.size20,
              color: Colors.black,
              onPressed: isRunning ? _onPausePressed : _onStartPressed,
              icon: Icon(isRunning
                  ? Icons.pause_circle_filled_outlined
                  : Icons.play_circle_outline),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: isRunning ? 1.0 : 0.0,
              child: isRunning
                  ? IconButton(
                      iconSize: 40,
                      color: Colors.black,
                      onPressed: _onResetPressed,
                      icon: const Icon(Icons.restart_alt_outlined),
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

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({
    super.key,
    required this.countScore,
    required this.maxScore,
    required this.text,
  });

  final int countScore, maxScore;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$countScore / $maxScore",
          style: const TextStyle(
            fontSize: Sizes.size32,
            fontWeight: FontWeight.w600,
            color: Color(0xFF232B55),
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF232B55),
          ),
        ),
      ],
    );
  }
}

class SelectedButton extends StatefulWidget {
  const SelectedButton({
    super.key,
    required this.time,
    required this.onSelected,
  });

  final int time;
  final ValueChanged<int> onSelected;

  @override
  State<SelectedButton> createState() => _SelectedButtonState();
}

class _SelectedButtonState extends State<SelectedButton> {
  bool _isSelected = false;

  void _onTap() {
    if (widget.time == 2) {
      widget.onSelected(widget.time);
    } else {
      widget.onSelected(widget.time * 60);
    }

    setState(() {
      _isSelected = !_isSelected;
    });
    Future.delayed(
      const Duration(milliseconds: 400),
      () => {
        setState(
          () {
            _isSelected = !_isSelected;
          },
        )
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedContainer(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(
          right: Sizes.size28,
        ),
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isSelected ? Colors.amber[50] : Colors.black,
          border: Border.all(
            color: Colors.black.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 5,
            ),
          ],
        ),
        child: (widget.time == 2)
            ? Text(
                "EX",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: _isSelected ? Colors.red : Colors.white,
                ),
              )
            : Text(
                "${widget.time}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _isSelected ? const Color(0xFF232B55) : Colors.white,
                ),
              ),
      ),
    );
  }
}
