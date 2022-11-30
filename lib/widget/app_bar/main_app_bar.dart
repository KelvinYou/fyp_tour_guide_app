import 'package:flutter/material.dart';
import 'package:fyp_project/ui_view/profile_setting_view.dart';
import 'package:fyp_project/utils/app_theme.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final IconData? rightButton;
  final VoidCallback? function;
  const MainAppBar({
    Key? key,
    required this.title,
    this.rightButton,
    this.function,
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
      actions: <Widget>[
        rightButton != null && VoidCallback != null ?
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: function,
              child: Icon( rightButton ),
            )
        ) : const SizedBox(),
      ],
    );

  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}
