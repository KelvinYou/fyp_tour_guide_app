import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/text_field_input.dart';

import 'package:fyp_project/utils/utils.dart';

import 'package:fyp_project/resources/auth_methods.dart';

import 'package:fyp_project/bottom_bar_view.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final currentPassword = TextEditingController();
  final repeatPassword = TextEditingController();
  final newPassword = TextEditingController();
  bool _isLoading = false;

  submit() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().changePassword(
         currentPassword.text, newPassword.text);

    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const BottomBarView(selectedIndex: 4)
          ), (route) => false);
      showSnackBar(context, "Password has been reset successfully.");
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: SecondaryAppBar(
          title: "Change Password",
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 25.0),

            // email textfield
            TextFieldInput(
                textEditingController: currentPassword,
                hintText: "Old Password",
                isPass: true,
                textInputType: TextInputType.text),

            const SizedBox(height: 20),

            TextFieldInput(
                textEditingController: repeatPassword,
                hintText: "Repeat Old Password",
                isPass: true,
                textInputType: TextInputType.text),

            const SizedBox(height: 20),

            TextFieldInput(
                textEditingController: newPassword,
                hintText: "New Password",
                isPass: true,
                textInputType: TextInputType.text),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: AppTheme.primary,
                ),
                child: Text('Confirm'),
                onPressed: submit,
              ),

            ),
          ],
        ),
      ),
    );
  }
}