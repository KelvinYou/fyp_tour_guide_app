import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:fyp_project/ui_view/login_view.dart';
import 'package:fyp_project/ui_view/profile_setting_view.dart';
import 'package:fyp_project/ui_view/register_view.dart';
import 'package:fyp_project/ui_view/personal_detail_view.dart';

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
  bool isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    return isLoading
      ? const Center(
        child: CircularProgressIndicator(),
      )
      : Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProfileSetting(),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Icon(
                        Icons.settings,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 56.0,
                      backgroundImage: NetworkImage(
                        userData["photoUrl"],
                      ),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(width: 10.0),

                    Column(
                      children: [
                        Text(userData['username']),
                        Text(userData['grade']),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: userData['rating'],
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 30.0,
                              direction: Axis.horizontal,
                            ),
                            Text(userData['rating'].toString()),
                          ],
                        ),

                      ],
                    )
                  ],
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
          ],
        ),
      ),
    );
  }


}