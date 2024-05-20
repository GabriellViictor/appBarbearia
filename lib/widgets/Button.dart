import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  String label;
  Function onPressed;
  bool progress;

  Button({
    required this.label,
    required this.onPressed,
    this.progress = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        shadowColor: Colors.black,
        elevation: 6.0,
      ),
      onPressed: () {
        onPressed();
      },
      child: progress
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
    );
  }
}