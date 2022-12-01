import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/colored_button.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/text_field_input.dart';

import 'package:fyp_project/bottom_bar_view.dart';
import 'package:fyp_project/ui_view/login_view.dart';
import 'package:fyp_project/resources/auth_methods.dart';
import 'package:fyp_project/utils/utils.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String usernameErrorMsg = "";
  String emailErrorMsg = "";
  String passwordErrorMsg = "";

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
      usernameErrorMsg = "";
      emailErrorMsg = "";
      passwordErrorMsg = "";
    });

    bool usernameFormatCorrected = false;
    bool emailFormatCorrected = false;
    bool passwordFormatCorrected = false;

    if (_usernameController.text == "") {
      setState(() {
        usernameErrorMsg = "Please enter your username";
      });
    } else {
      usernameFormatCorrected = true;
    }

    if (_emailController.text == "") {
      setState(() {
        emailErrorMsg = "Please enter your email address";
      });
    } else {
      emailFormatCorrected = true;
    }

    if (_passwordController.text == "") {
      setState(() {
        passwordErrorMsg = "Please enter your password";
      });
    } else {
      passwordFormatCorrected = true;
    }

    if (usernameFormatCorrected && usernameFormatCorrected && usernameFormatCorrected) {
      String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,);

      // if string returned is success, user has been created
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        // navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const BottomBarView(selectedIndex: 0),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        // show the error
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
      appBar: const SecondaryAppBar(
        title: "Register an Account"
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
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
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 25.0),
                // user name textfield
                TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: "Username",
                  textInputType: TextInputType.text,
                  errorMsg: usernameErrorMsg,
                  iconData: Icons.person,
                ),

                const SizedBox(height: 10.0),

                // email textfield
                TextFieldInput(
                  textEditingController: _emailController,
                  hintText: "Email",
                  textInputType: TextInputType.emailAddress,
                  errorMsg: emailErrorMsg,
                  iconData: Icons.email_outlined,
                ),

                const SizedBox(height: 10.0),
                // password textfield
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: "Password",
                  isPass: true,
                  textInputType: TextInputType.text,
                  errorMsg: passwordErrorMsg,
                  iconData: Icons.lock_open_sharp,
                ),

                const SizedBox(height: 10.0),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: ColoredButton(
                      childText: "Register",
                      onPressed: signUpUser,
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      ),
                      child: Text(
                        " Login",
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
      ),
    );
  }

}