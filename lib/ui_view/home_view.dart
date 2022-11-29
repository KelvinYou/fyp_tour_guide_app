import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/utils/app_theme.dart';

import 'package:fyp_project/ui_view/instant_order_view.dart';
import 'package:fyp_project/ui_view/tour_package_view.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/widget/main_app_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
      child: Text(
        title,
      ),
    );
  }
  Widget build(BuildContext context) {
    return isLoading
      ? const Center(
        child: CircularProgressIndicator(),
      )
    : Scaffold(
      appBar: MainAppBar(title: "Welcome Back, ${userData["username"]}"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mainTitle("Tour Guide Training Programs"),
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
            ),
            items: [1,2,3,4,5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      // margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        boxShadow: const [ AppTheme.boxShadow ],
                      ),
                      child: Text('text $i', style: TextStyle(fontSize: 16.0),)
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20.0),
          mainTitle("Start Your Tour Journey"),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: hourlyOrder,
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.person,
                                size: 35,
                              ),
                              Text("Hourly Order"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: tourPackage,
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.person,
                                size: 35,
                              ),
                              Text("Tour Package"),
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
        ],
      ),
    );
  }
}