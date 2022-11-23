import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/ui_view/guide_detail_view.dart';

import 'package:fyp_project/widget/app_theme.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Profile Setting'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ChangeProfile(),
                ),
              ),
              child: const Text(
                "change profile picture",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PersonalDetail(),
                ),
              ),
              child: const Text(
                "edit personal detail",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const GuideDetail(),
                ),
              ),
              child: const Text(
                "edit guide detail",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ResetEmail(),
                ),
              ),
              child: const Text(
                "reset email",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ResetPassword(),
                ),
              ),
              child: const Text(
                "reset password",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
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
              child: const Text(
                "Logout",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}