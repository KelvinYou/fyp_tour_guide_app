import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/colored_button.dart';
import 'package:fyp_project/widget/loading_view.dart';
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
  final password = TextEditingController();
  final newEmail = TextEditingController();
  bool _isLoading = false;
  String passwordErrorMsg = "";
  String newEmailErrorMsg = "";

  submit() async {
    setState(() {
      _isLoading = true;
      passwordErrorMsg = "";
      newEmailErrorMsg = "";
    });

    bool passwordFormatCorrected = false;
    bool newEmailFormatCorrected = false;

    if (password.text == "") {
      setState(() {
        passwordErrorMsg = "Please enter your password.";
      });
    } else if (password.text.length < 6) {
      setState(() {
        passwordErrorMsg = "Please enter at least 6 or more characters.";
      });
    } else {
      passwordFormatCorrected = true;
    }

    if (newEmail.text == "") {
      setState(() {
        newEmailErrorMsg = "Please enter your email address.";
      });
    } else if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(newEmail.text)) {
      setState(() {
        newEmailErrorMsg = "Incorrect email format.\nE.g. correct email: name@email.com.";
      });
    } else {
      newEmailFormatCorrected = true;
    }

    if (passwordFormatCorrected && newEmailFormatCorrected) {
      String email = FirebaseAuth.instance.currentUser!.email ?? "";
      String res = await AuthMethods().changeEmail(
          email,
          password.text,
          newEmail.text
      );

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const BottomBarView(selectedIndex: 4)
            ), (route) => false);
        showSnackBar(context, "Email has been changed successfully.");
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, res);
      }
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
          title: "Change Email"
      ),
      body: _isLoading ? LoadingView() : Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child:  SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 25.0),

              TextFieldInput(
                textEditingController: password,
                hintText: "Password",
                isPass: true,
                textInputType: TextInputType.text,
                errorMsg: passwordErrorMsg,
              ),
              const SizedBox(height: 20),
              TextFieldInput(
                textEditingController: newEmail,
                hintText: "New Email",
                textInputType: TextInputType.emailAddress,
                errorMsg: newEmailErrorMsg,
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