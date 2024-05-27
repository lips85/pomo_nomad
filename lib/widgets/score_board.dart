import 'package:flutter/material.dart';
import 'package:pomo_nomad/constants/sizes.dart';

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
