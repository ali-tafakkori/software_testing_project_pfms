import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final VoidCallback? onPressed;
  final Color color;
  final Color disabledColor;
  final Color textColor;

  const AppButton({
    super.key,
    required this.text,
    this.height = 48,
    this.width = double.infinity,
    required this.onPressed,
    this.color = Colors.amber,
    this.disabledColor = Colors.grey,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height,
      minWidth: width,
      onPressed: onPressed,
      color: color,
      disabledColor: disabledColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 17,
        ),
      ),
    );
  }
}
