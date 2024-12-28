import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

enum AppProgressButtonState { idle, loading }

class AppProgressButton extends StatelessWidget {
  final AppProgressButtonState state;
  final String text;
  final double height;
  final double width;
  final VoidCallback? onPressed;
  final Color color;
  final Color disabledColor;
  final Color childColor;

  const AppProgressButton({
    super.key,
    required this.state,
    required this.text,
    this.height = 48,
    this.width = double.infinity,
    required this.onPressed,
    this.color = Colors.amber,
    this.disabledColor = Colors.grey,
    this.childColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    Widget? child;
    switch (state) {
      case AppProgressButtonState.idle:
        child = Text(
          text,
          style: TextStyle(
            color: childColor,
            fontSize: 17,
          ),
        );
        break;
      case AppProgressButtonState.loading:
        child = LoadingAnimationWidget.horizontalRotatingDots(
          color: Colors.white,
          size: height,
        );
        break;
    }

    return MaterialButton(
      disabledElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      focusElevation: 0,
      elevation: 0,
      height: height,
      minWidth: width,
      onPressed: onPressed,
      color: color,
      splashColor: Colors.amberAccent,
      disabledColor: disabledColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
