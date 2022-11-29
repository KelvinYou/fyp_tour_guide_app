import 'package:flutter/material.dart';
import 'package:fyp_project/utils/app_theme.dart';

class ColoredButton extends StatelessWidget {

  final Widget child;
  final VoidCallback onPressed;

  ColoredButton({
    required this.onPressed,
    required this.child,});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Ink(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25.0),
            constraints: BoxConstraints(
                maxWidth: 200.0,
                minHeight: 50.0),
            alignment: Alignment.center,
            child: child
        ),
      ),
      splashColor: Colors.black12,
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(5.0),
      ),
    );
  }
}