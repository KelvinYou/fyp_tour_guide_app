import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/utils/themeModeNotifier.dart';
import 'package:fyp_project/widget/text_field_input.dart';

import 'package:fyp_project/resources/auth_methods.dart';
import 'package:fyp_project/ui_view/home_view.dart';
import 'package:fyp_project/bottom_bar_view.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/ui_view/register_view.dart';
import 'package:provider/provider.dart';

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
        emailErrorMsg = "Please enter your email address";
      });
    } else {
      emailFormatCorrected = true;
    }

    if (passwordController.text == "") {
      setState(() {
        passwordErrorMsg = "Please enter your password";
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Center(
          child: Text('Welcome To Travel Guide'),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          // width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  fontSize: 24,
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

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text('Login'),
                  onPressed: signIn,
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
          )
        )
      )
    );
  }

}