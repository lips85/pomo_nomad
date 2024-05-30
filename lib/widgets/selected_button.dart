import 'package:flutter/material.dart';
import '../../../constants/sizes.dart';

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
    final int seconds = widget.time == 2 ? widget.time : widget.time * 60;
    widget.onSelected(seconds);

    setState(() {
      _isSelected = !_isSelected;
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _isSelected = !_isSelected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedContainer(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(right: Sizes.size28),
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isSelected ? Colors.black.withOpacity(0.9) : Colors.amber[50],
          border: Border.all(
            width: 5,
            color: Colors.black.withOpacity(0.8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Text(
          "${widget.time}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: _isSelected
                ? Colors.amber[50]
                : const Color.fromARGB(255, 34, 41, 72),
          ),
        ),
      ),
    );
  }
}
