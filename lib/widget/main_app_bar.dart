import 'package:flutter/material.dart';
import 'package:fyp_project/ui_view/profile_setting_view.dart';
import 'package:fyp_project/utils/app_theme.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final IconData rightButton;
  const MainAppBar({
    Key? key,
    required this.title,
    this.rightButton = Icons.settings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      centerTitle: true,
      title: Text(title),
      elevation: 0,
      actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileSetting(),
                ),
              ),
              child: Icon( rightButton ),
            )
        ),
      ],
    );

  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}
