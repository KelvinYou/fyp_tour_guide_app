import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/ui_view/theme_mode_view.dart';
import 'package:fyp_project/ui_view/guide_detail_view.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/resources/auth_methods.dart';

import 'package:fyp_project/ui_view/login_view.dart';
import 'package:fyp_project/ui_view/change_profile_view.dart';
import 'package:fyp_project/ui_view/change_email_view.dart';
import 'package:fyp_project/ui_view/change_password_view.dart';
import 'package:fyp_project/ui_view/personal_detail_view.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  void logout() async {
    await AuthMethods().signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) =>
        const Login(),
      ), (Route<dynamic> route) => false
    );
  }

  Widget selectionView(IconData icon, String title) {
    return Column(
      children: [
        const Divider(
          height: 2,
          thickness: 2,
          indent: 0,
          endIndent: 0,
          color: AppTheme.lightGrey,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
          color: CupertinoColors.systemGrey5,
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 10.0),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: CupertinoColors.black,
                    ),
                  ),
                ],
              ),

              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Setting'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10.0),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ChangeProfile(),
              ),
            ),
            child: selectionView(
              Icons.image_outlined,
              "Change Profile Picture"
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PersonalDetail(),
              ),
            ),
            child: selectionView(
              CupertinoIcons.profile_circled,
              "Edit Personal Detail"
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const GuideDetail(),
              ),
            ),
            child: selectionView(
                Icons.image_outlined,
                "Edit Guide Detail"
            ),
          ),
          const Divider(
            height: 2,
            thickness: 2,
            indent: 0,
            endIndent: 0,
            color: AppTheme.lightGrey,
          ),
          const SizedBox(height: 10.0),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ThemeModeView(),
              ),
            ),
            child: selectionView(
              Icons.dark_mode,
              "Dark Mode"
            ),
          ),
          GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ThemeModeView(),
                ),
              ),
              child: selectionView(Icons.image_outlined, "System Language")
          ),
          const Divider(
            height: 2,
            thickness: 2,
            indent: 0,
            endIndent: 0,
            color: AppTheme.lightGrey,
          ),
          const SizedBox(height: 10.0),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ResetEmail(),
              ),
            ),
            child: selectionView(Icons.image_outlined, "Reset Email")
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ResetPassword(),
              ),
            ),
            child: selectionView(Icons.image_outlined, "Reset Password")
          ),
          const Divider(
            height: 2,
            thickness: 2,
            indent: 0,
            endIndent: 0,
            color: AppTheme.lightGrey,
          ),
          const SizedBox(height: 10.0),
          const Divider(
            height: 2,
            thickness: 2,
            indent: 0,
            endIndent: 0,
            color: AppTheme.lightGrey,
          ),
          GestureDetector(
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Confirm Logout?'),
                content: const Text('Logout now'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: logout,
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey5,
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: Text(
                "Logout",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: CupertinoColors.black,
                ),
              ),
            ),
          ),
          const Divider(
            height: 2,
            thickness: 2,
            indent: 0,
            endIndent: 0,
            color: AppTheme.lightGrey,
          ),
        ],
      ),
      ),
    );
  }
}