import 'package:flutter/material.dart';
import 'package:fyp_project/utils/app_theme.dart';

class MainContainer extends StatelessWidget {
  final Widget child;

  MainContainer({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            offset: Offset(
              0.0,
              1.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: child
    );
  }
}