import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/widget/app_theme.dart';
import 'package:fyp_project/widget/text_field_input.dart';

import 'package:fyp_project/utils/utils.dart';

import 'package:fyp_project/resources/auth_methods.dart';

import 'package:fyp_project/bottom_bar_view.dart';

class ResetEmail extends StatefulWidget {
  const ResetEmail({super.key});

  @override
  State<ResetEmail> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetEmail> {
  final currentEmail = TextEditingController();
  final newEmail = TextEditingController();
  bool _isLoading = false;

  submit() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().changeEmail(
        currentEmail.text, newEmail.text);

    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const BottomBarView(selectedIndex: 4)
          ), (route) => false);
      showSnackBar(context, "Email has been reset successfully.");
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
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Change Email'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 25.0),

            TextFieldInput(
                textEditingController: newEmail,
                hintText: "New Email",
                textInputType: TextInputType.emailAddress),

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