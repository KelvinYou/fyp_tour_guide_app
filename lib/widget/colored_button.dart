import 'package:flutter/material.dart';
import 'package:fyp_project/utils/app_theme.dart';

class ColoredButton extends StatelessWidget {

  final String childText;
  final VoidCallback onPressed;

  ColoredButton({
    required this.onPressed,
    required this.childText,});

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
                minHeight: 40.0
            ),
            alignment: Alignment.center,
            child: Text(
              childText,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
        ),
      ),
      splashColor: Colors.black12,
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}