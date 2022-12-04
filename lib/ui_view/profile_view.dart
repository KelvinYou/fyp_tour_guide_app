import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyp_project/ui_view/change_profile_view.dart';
import 'package:fyp_project/ui_view/rating_view.dart';
import 'package:fyp_project/ui_view/licence_view.dart';

import 'package:fyp_project/ui_view/login_view.dart';
import 'package:fyp_project/ui_view/profile_setting_view.dart';
import 'package:fyp_project/ui_view/register_view.dart';
import 'package:fyp_project/ui_view/edit_profile_view.dart';
import 'package:fyp_project/ui_view/verify_ic_view.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/resources/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/providers/user_provider.dart';
import 'package:fyp_project/widget/app_bar/main_app_bar.dart';
import 'package:fyp_project/widget/main_container.dart';

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

    // AuthMethods().signOut();
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(
    //       builder: (context) =>
    //       const Login(),
    //     ), (Route<dynamic> route) => false
    // );
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

  Widget selectionView(IconData icon, String title) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 10.0),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),

              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
      ? const Center(
        child: CircularProgressIndicator(),
      )
      : Scaffold(
      appBar: MainAppBar(
        title: "Profile",
        rightButton: Icons.settings,
        function: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ProfileSetting(),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ChangeProfile(),
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 56.0,
                        backgroundImage: NetworkImage(
                          userData["photoUrl"],
                        ),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 10.0),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData['username'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [ AppTheme.boxShadow ],
                            color: Colors.yellow,
                          ),
                          child: Text(
                            userData['grade'],
                            style: TextStyle(
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: userData['rating'],
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 24.0,
                              direction: Axis.horizontal,
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              userData['rating'].toString(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onPrimary
                              ),
                            ),
                          ],
                        ),

                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20.0),
              MainContainer(
                needPadding: true,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const VerifyIcView()),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.person_pin_outlined,
                                    size: 35,
                                  ),
                                  Text("Verify"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LicenceView()),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.card_travel,
                                    size: 35,
                                  ),
                                  Text("Licence"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RatingView()),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.grade_outlined,
                                    size: 35,
                                  ),
                                  Text("Rating"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RatingView()),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 35,
                                  ),
                                  Text("History"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              MainContainer(
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProfileSetting(),
                          ),
                        ),
                        child: selectionView(Icons.settings, "Setting")
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: AppTheme.lightGrey,
                    ),
                    GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProfileSetting(),
                          ),
                        ),
                        child: selectionView(Icons.group, "About Us")
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}