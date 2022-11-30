import 'package:flutter/material.dart';
import 'package:fyp_project/ui_view/profile_setting_view.dart';
import 'package:fyp_project/utils/app_theme.dart';

class SecondaryAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final IconData rightButton;
  const SecondaryAppBar({
    Key? key,
    required this.title,
    this.rightButton = Icons.settings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      iconTheme: IconThemeData(
          color: Colors.white
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
          title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      elevation: 0,
    );

  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}
