import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../constants/sizes.dart';

class SelectedButton extends StatefulWidget {
  const SelectedButton({
    super.key,
    required this.time,
  });

  final String time;

  @override
  State<SelectedButton> createState() => _SelectedButtonState();
}

class _SelectedButtonState extends State<SelectedButton> {
  bool _isSelected = false;
  late String selctedTime;

  void _onTap() {
    selctedTime = widget.time;

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
        margin: const EdgeInsets.only(
          right: Sizes.size16,
        ),
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: _isSelected ? Colors.amber[50] : Colors.black,
          borderRadius: BorderRadius.circular(
            Sizes.size96,
          ),
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
        child: CupertinoButton(
          child: Text(
            widget.time,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  _isSelected ? Theme.of(context).primaryColor : Colors.white,
            ),
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
