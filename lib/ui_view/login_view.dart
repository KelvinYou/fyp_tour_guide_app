import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/app_theme.dart';

import 'package:fyp_project/resources/auth_methods.dart';
import 'package:fyp_project/ui_view/home_view.dart';
import 'package:fyp_project/bottom_bar_view.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/ui_view/register_view.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }
  // Login Function
  // static Future<User?> loginUsingEmailPassword(required String email, required String password, required BuildContext context) async {

  // }
  void signIn() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
        email: emailController.text, password: passwordController.text);
    print(res);
    if (res == 'success') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const BottomBarView()
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
      // showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Log In'),
      ),
      body: SafeArea(
        child: Center(
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
              // const Text(
              //   "Login",
              //   style: AppTheme.headline,
              // ),
              // const SizedBox(height: 15),

              // email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.nearlyWhite,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [ AppTheme.boxShadow ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Username / Email / Phone Number',
                      ),
                    ),
                  ),
                ),

              ),

              const SizedBox(height: 20),

              // password textfield
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.nearlyWhite,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [ AppTheme.boxShadow ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                          ),
                        ),
                      ),
                  ),

              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppTheme.primary,
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
                    child: const Text(
                      " Register Now",
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