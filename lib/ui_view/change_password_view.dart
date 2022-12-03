import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/colored_button.dart';
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
  final reenterPassword = TextEditingController();
  final newPassword = TextEditingController();
  bool _isLoading = false;
  String currentPasswordErrorMsg = "";
  String reenterPasswordErrorMsg = "";
  String newPasswordErrorMsg = "";

  submit() async {
    setState(() {
      _isLoading = true;
      currentPasswordErrorMsg = "";
      reenterPasswordErrorMsg = "";
      newPasswordErrorMsg = "";
    });

    bool currentPasswordFormatCorrected = false;
    bool reenterPasswordFormatCorrected = false;
    bool newPasswordFormatCorrected = false;

    if (currentPassword.text == "") {
      setState(() {
        currentPasswordErrorMsg = "Please enter your password.";
      });
    } else if (currentPassword.text.length < 6) {
      setState(() {
        currentPasswordErrorMsg = "Please enter at least 6 or more characters.";
      });
    } else {
      currentPasswordFormatCorrected = true;
    }

    if (newPassword.text == "") {
      setState(() {
        newPasswordErrorMsg = "Please enter your new password.";
      });
    } else if (newPassword.text.length < 6) {
      setState(() {
        newPasswordErrorMsg = "Please enter at least 6 or more characters.";
      });
    } else {
      newPasswordFormatCorrected = true;
    }

    if (reenterPassword.text == "") {
      setState(() {
        reenterPasswordErrorMsg = "Please enter your new password.";
      });
    } else if (reenterPassword.text.length < 6) {
      setState(() {
        reenterPasswordErrorMsg = "Please enter at least 6 or more characters.";
      });
    } else if (newPassword.text != reenterPassword.text) {
      setState(() {
        reenterPasswordErrorMsg = "The password doesn't match the password enter above.";
      });
    } else {
      reenterPasswordFormatCorrected = true;
    }

    if (currentPasswordFormatCorrected && reenterPasswordFormatCorrected
    && newPasswordFormatCorrected) {
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
    setState(() {
      _isLoading = false;
    });
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
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child:  SingleChildScrollView(
    child: Column(
          children: [
            const SizedBox(height: 25.0),

            // email textfield
            TextFieldInput(
              textEditingController: currentPassword,
              hintText: "Old Password",
              isPass: true,
              textInputType: TextInputType.text,
              errorMsg: currentPasswordErrorMsg,
            ),

            const SizedBox(height: 20),

            TextFieldInput(
              textEditingController: newPassword,
              hintText: "New Password",
              isPass: true,
              textInputType: TextInputType.text,
              errorMsg: newPasswordErrorMsg,
            ),

            const SizedBox(height: 20),
            TextFieldInput(
              textEditingController: reenterPassword,
              hintText: "Reenter New Password",
              isPass: true,
              textInputType: TextInputType.text,
              errorMsg: reenterPasswordErrorMsg,
            ),

            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: ColoredButton(onPressed: submit, childText: 'Confirm'),
            ),


          ],
        ),
      ),
      ),
    );
  }
}