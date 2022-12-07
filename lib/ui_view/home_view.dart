import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyp_project/ui_view/change_profile_view.dart';
import 'package:fyp_project/ui_view/guide_detail_view.dart';
import 'package:fyp_project/ui_view/edit_profile_view.dart';
import 'package:fyp_project/utils/app_theme.dart';

import 'package:fyp_project/ui_view/instant_order_view.dart';
import 'package:fyp_project/ui_view/tour_package_view.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/widget/app_bar/main_app_bar.dart';
import 'package:fyp_project/widget/loading_view.dart';
import 'package:fyp_project/widget/main_container.dart';
import 'package:fyp_project/ui_view/verify_ic_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var userData = {};
  var instantOrderData = {};
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

      var instantOrderSnap = await FirebaseFirestore.instance
          .collection('instantOrder')
          .doc("instant_${FirebaseAuth.instance.currentUser!.uid}")
          .get();

      userData = userSnap.data()!;
      instantOrderData = instantOrderSnap.data()!;

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

  void hourlyOrder() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InstantOrder()),
    );
  }

  void tourPackage() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TourPackage()),
    );
  }

  Widget selectionView(IconData icon, String title) {
    return Container(
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
    );
  }

  Widget build(BuildContext context) {
    double width = MediaQuery. of(context). size. width;
    double height = MediaQuery. of(context). size. height;

    return Scaffold(
      appBar: MainAppBar(title: "Travel Guide"),
      body: isLoading ? LoadingView() : Container(
        // width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Welcome, ${userData["username"]}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "- Start Your Tour Journey -",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              MainContainer(
                child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: GestureDetector(
                          onTap: hourlyOrder,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        "My Hourly Order",
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "On duty:",
                                          style: TextStyle(
                                          ),
                                        ),

                                        Switch(
                                          value: instantOrderData["onDuty"],
                                          onChanged: (value) {
                                            setState(() {
                                            });
                                          },
                                          activeTrackColor: Colors.lightBlueAccent,
                                          activeColor: AppTheme.primary,
                                        ),
                                      ],
                                    ),
                                    Text("Price: RM ${instantOrderData["price"].toStringAsFixed(2)}  / Hour"),
                                  ],
                                ),
                                Icon(Icons.chevron_right)
                              ],
                            ),
                          ),
                        ),
                      ),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                        color: AppTheme.lightGrey,
                      ),
                      GestureDetector(
                        onTap: tourPackage,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Center(
                                    child: Text(
                                      "My Tour Package",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Icon(Icons.chevron_right)
                            ],
                          ),
                        ),
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
                            builder: (context) => const GuideDetail(),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Guide Detail",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Icon(Icons.edit_note_outlined),
                                ],
                              )
                            ),

                            Padding(
                              padding: EdgeInsets.all(10),
                              child: SizedBox(
                                width: width - 80,
                                child: Text(
                                  "Description : ${
                                      userData["description"] != "" ?
                                      userData["description"]
                                          : "No description"}",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
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
                          builder: (context) => const EditProfileView(),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Personal Detail",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Icon(Icons.edit_note_outlined),
                                  ],
                                )
                            ),
                            const SizedBox(height: 5),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: (width - 80) / 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Username:"),
                                        const SizedBox(height: 5),
                                        Text("Full Name:"),
                                        const SizedBox(height: 5),
                                        Text("Phone Number:"),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: (width - 80) * 2 / 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(userData["username"] != "" ? userData["username"] : "[No username]"),
                                        const SizedBox(height: 5),
                                        Text(userData["fullname"] != "" ? userData["fullname"] : "[No full name]"),
                                        const SizedBox(height: 5),
                                        Text(userData["phoneNumber"] != "" ? userData["phoneNumber"] : "[No phone number]"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                          builder: (context) => const VerifyIcView(),
                        ),
                      ),
                      child: selectionView(
                          Icons.person_pin_circle_outlined,
                          "Verify IC"
                      ),
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