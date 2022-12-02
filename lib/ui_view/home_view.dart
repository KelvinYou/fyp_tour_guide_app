import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyp_project/ui_view/change_profile_view.dart';
import 'package:fyp_project/ui_view/guide_detail_view.dart';
import 'package:fyp_project/ui_view/personal_detail_view.dart';
import 'package:fyp_project/utils/app_theme.dart';

import 'package:fyp_project/ui_view/instant_order_view.dart';
import 'package:fyp_project/ui_view/tour_package_view.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/widget/app_bar/main_app_bar.dart';
import 'package:fyp_project/widget/main_container.dart';

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
  Widget mainTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
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
    return isLoading
      ? const Center(
        child: CircularProgressIndicator(),
      )
    : Scaffold(
      appBar: MainAppBar(title: "Welcome, ${userData["username"]}"),
      body: Container(
        // width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mainTitle("Start Your Tour Journey"),
              MainContainer(
                needPadding: true,
                child: Column(
                  children: [
                    Text(
                      "My Personal Detail",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Username"),
                            const SizedBox(height: 5),
                            Text("Full Name"),
                            const SizedBox(height: 5),
                            Text("Phone Number"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userData["username"] != "" ? userData["username"] : "[No username]"),
                            const SizedBox(height: 5),
                            Text(userData["fullname"] != "" ? userData["fullname"] : "[No full name]"),
                            const SizedBox(height: 5),
                            Text(userData["phoneNumber"] != "" ? userData["phoneNumber"] : "[No phone number]"),
                          ],
                        ),
                        IconButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const PersonalDetail(),
                              ),
                            ),
                            icon: Icon(Icons.edit_note_outlined)
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: AppTheme.lightGrey,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "My Guide Detail",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description : ${
                                  userData["description"] != "" ?
                                  userData["description"]
                                      : "No description"}",
                            ),
                          ],
                        ),

                        IconButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const GuideDetail(),
                              ),
                            ),
                            icon: Icon(Icons.edit_note_outlined)
                        ),
                      ],
                    ),
                  ],
                )
              ),
              const SizedBox(height: 20,),
              MainContainer(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      GestureDetector(
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
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "On duty",
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
                      const SizedBox(height: 10,),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                        color: AppTheme.lightGrey,
                      ),
                      const SizedBox(height: 10,),
                      GestureDetector(
                        onTap: tourPackage,
                        child: Container(
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
                                        fontWeight: FontWeight.w500,
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              MainContainer(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PersonalDetail(),
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