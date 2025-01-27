import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget{
  final String buttonText;
  final Color? buttonColor;
  final Color? textColor;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.buttonText,
    this.buttonColor = Colors.green,
    this.textColor = Colors.white,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: textColor,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}