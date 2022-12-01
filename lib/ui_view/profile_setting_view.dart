import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/ui_view/change_language_view.dart';
import 'package:fyp_project/ui_view/theme_mode_view.dart';
import 'package:fyp_project/ui_view/guide_detail_view.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/resources/auth_methods.dart';

import 'package:fyp_project/ui_view/login_view.dart';
import 'package:fyp_project/ui_view/change_profile_view.dart';
import 'package:fyp_project/ui_view/change_email_view.dart';
import 'package:fyp_project/ui_view/change_password_view.dart';
import 'package:fyp_project/ui_view/personal_detail_view.dart';
import 'package:fyp_project/ui_view/coming_soon_view.dart';
import 'package:fyp_project/ui_view/bank_card_view.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/main_container.dart';

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
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onPrimary,
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
      appBar: SecondaryAppBar(
          title: "Setting"
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10.0),
          MainContainer(
            child: Column(
              children: [
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
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: AppTheme.lightGrey,
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
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: AppTheme.lightGrey,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GuideDetail(),
                    ),
                  ),
                  child: selectionView(
                      Icons.shopping_bag_outlined,
                      "Edit Guide Detail"
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: AppTheme.lightGrey,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PersonalDetail(),
                    ),
                  ),
                  child: selectionView(
                      Icons.person_pin_circle_outlined,
                      "Verify IC"
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: AppTheme.lightGrey,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BankCardView(),
                    ),
                  ),
                  child: selectionView(
                      Icons.credit_card,
                      "Bank Card"
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20.0),

          MainContainer(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ThemeModeView(),
                    ),
                  ),
                  child: selectionView(
                      Icons.dark_mode_outlined,
                      "Light / Dark Mode"
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: AppTheme.lightGrey,
                ),
                GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ChangeLanguageView(),
                      ),
                    ),
                    child: selectionView(Icons.language_outlined, "System Language")
                ),
              ],
            ),
          ),

          const SizedBox(height: 20.0),

          MainContainer(
            child: Column(
              children: [
                GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ResetEmail(),
                      ),
                    ),
                    child: selectionView(Icons.email_outlined, "Reset Email")
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: AppTheme.lightGrey,
                ),
                GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ResetPassword(),
                      ),
                    ),
                    child: selectionView(Icons.security_outlined, "Reset Password")
                ),
              ],
            )
          ),

          const SizedBox(height: 20.0),

          GestureDetector(
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Confirm Logout?'),
                // content: const Text('Logout now'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: logout,
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            child: MainContainer(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}