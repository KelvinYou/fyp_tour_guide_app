import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/utils/themeModeNotifier.dart';
import 'package:fyp_project/widget/colored_button.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/text_field_input.dart';

import 'package:fyp_project/resources/auth_methods.dart';
import 'package:fyp_project/ui_view/home_view.dart';
import 'package:fyp_project/bottom_bar_view.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/ui_view/register_view.dart';
import 'package:provider/provider.dart';

import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String emailErrorMsg = "";
  String passwordErrorMsg = "";
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signIn() async {
    setState(() {
      _isLoading = true;
      emailErrorMsg = "";
      passwordErrorMsg = "";
    });

    bool emailFormatCorrected = false;
    bool passwordFormatCorrected = false;

    if (emailController.text == "") {
      setState(() {
        emailErrorMsg = "Please enter your email address.";
      });
    } else if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text)) {
      setState(() {
        emailErrorMsg = "Incorrect email format.\nE.g. correct email: name@email.com.";
      });
    } else {
      emailFormatCorrected = true;
    }

    if (passwordController.text == "") {
      setState(() {
        passwordErrorMsg = "Please enter your password.";
      });
    } else if (passwordController.text.length < 6) {
      setState(() {
        passwordErrorMsg = "Please enter at least 6 or more characters.";
      });
    } else {
      passwordFormatCorrected = true;
    }

    if (emailFormatCorrected && passwordFormatCorrected) {
      String res = await AuthMethods().loginUser(
          email: emailController.text, password: passwordController.text);
      if (res == 'success') {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const BottomBarView(selectedIndex: 0)
            ),
                (route) => false);

        setState(() {
          _isLoading = false;
        });
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
    return
    //   _isLoading
    //     ? const Center(
    //   child: CircularProgressIndicator(),
    // ) :
    Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const SecondaryAppBar(
          title: "Welcome To Travel Guide"
      ),
      body: Container(
          // width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
            child: SingleChildScrollView(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50.0),
                Container(
                  margin: const EdgeInsets.only(left: 30.0),
                  child: const Image(
                    width: 150,
                    image: AssetImage('assets/logo.png'),
                  ),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  "Travel Guide",
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  "App For Tour Guide",
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 25.0),

                // email textfield
                TextFieldInput(
                  textEditingController: emailController,
                  hintText: "Email",
                  textInputType: TextInputType.emailAddress,
                  iconData: Icons.email_outlined,
                  errorMsg: emailErrorMsg,),

                const SizedBox(height: 10.0),

                // password textfield
                TextFieldInput(
                  textEditingController: passwordController,
                  hintText: "Password",
                  isPass: true,
                  textInputType: TextInputType.text,
                  iconData: Icons.lock_open_sharp,
                  errorMsg: passwordErrorMsg,),

                const SizedBox(height: 10.0),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: ColoredButton(
                      childText: "login",
                      onPressed: signIn
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Not a member?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Register(),
                        ),
                      ),
                      child: Text(
                        " Register Now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
        ),
      ),
    );
  }

}