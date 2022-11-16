import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/ui_view/login_view.dart';
import 'package:fyp_project/ui_view/register_view.dart';
import 'package:fyp_project/widget/app_theme.dart';
import 'package:fyp_project/resources/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/providers/user_provider.dart';

class Profile extends StatefulWidget {
  final String uid;
  const Profile({Key? key, required this.uid}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static const String title = 'Profile';
  var userData = {};
  int counter = 0;
  bool isLogin = false;
  bool isLoading = false;
  String myEmail = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('tourGuides')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  void logout() async {
    await AuthMethods().signOut();
    Navigator.of(context)
        .pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
        const Login(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppTheme.nearlyWhite,
      //   elevation: 0.0,
      //   title: const Text(
      //     'Profile',
      //     style: TextStyle(
      //       color: Colors.black,
      //     )
      //   ),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 56.0,
                      backgroundImage: AssetImage('assets/erza.jpg'),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(width: 10.0),
                    Text(userData['username'] ?? 'sohai'),
                  ],
                ),
            ),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: Row(
            //     children: [
            //       const CircleAvatar(
            //         radius: 56.0,
            //         backgroundImage: AssetImage('assets/erza.jpg'),
            //         backgroundColor: Colors.white,
            //       ),
            //       const SizedBox(width: 10.0),
            //       Expanded(
            //         child: ElevatedButton(
            //           style: ElevatedButton.styleFrom(
            //             primary: AppTheme.nearlyWhite,
            //             side: const BorderSide(width: 1.0, color: AppTheme.primary,),
            //           ),
            //           child: const Text(
            //             'Login',
            //             style: TextStyle(
            //               color: AppTheme.primary,
            //             ),
            //           ),
            //           onPressed: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(builder: (context) => const Login()),
            //             );
            //           },
            //         ),
            //       ),
            //       const SizedBox(width: 10.0),
            //       Expanded(
            //         child: ElevatedButton(
            //           style: ElevatedButton.styleFrom(
            //             primary: AppTheme.primary,
            //           ),
            //           child: Text('Register'),
            //           onPressed: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(builder: (context) => const Register()),
            //             );
            //           },
            //         ),
            //       ),
            //
            //     ],
            //   ),
            // ),


            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: AppTheme.nearlyWhite,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [ AppTheme.boxShadow ],
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        " My Status",
                        style: AppTheme.subHeadline,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 35,
                                  ),
                                  Text("2FA"),
                                ],
                              ),
                            ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 35,
                                ),
                                Text("Licence"),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 35,
                                ),
                                Text("History"),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 35,
                                ),
                                Text("Grade"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: AppTheme.nearlyWhite,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [ AppTheme.boxShadow ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 20.0),
                        Icon(Icons.help_center),
                        const SizedBox(width: 20.0),
                        Text("Help Center"),
                      ],
                    ),
                    const Divider(
                      height: 20,
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                      color: AppTheme.lightGrey,
                    ),
                    Row(
                      children: const [
                        SizedBox(width: 20.0),
                        Icon(Icons.chat_outlined),
                        SizedBox(width: 20.0),
                        Text("Chat With Admin"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: logout,
              child: const Text(
                "Logout",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}