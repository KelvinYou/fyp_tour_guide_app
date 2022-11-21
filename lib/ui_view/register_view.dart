import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/widget/app_theme.dart';
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
    });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          title: const Text('Register'),
        ),
        body: SafeArea(
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25.0),
                    const Text(
                      "Register",
                      style: AppTheme.headline,
                    ),
                    const SizedBox(height: 10),

                    // user name textfield
                    TextFieldInput(
                        textEditingController: _usernameController,
                        hintText: "Username",
                        textInputType: TextInputType.text),

                    const SizedBox(height: 15),

                    // email textfield
                    TextFieldInput(
                        textEditingController: _emailController,
                        hintText: "Email",
                        textInputType: TextInputType.emailAddress),

                    const SizedBox(height: 15),
                    // password textfield
                    TextFieldInput(
                        textEditingController: _passwordController,
                        hintText: "Password",
                        isPass: true,
                        textInputType: TextInputType.text),

                    const SizedBox(height: 15),

                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: signUpUser,
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
                          child: const Text(
                            " Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
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