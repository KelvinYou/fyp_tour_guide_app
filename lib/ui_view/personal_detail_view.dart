import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/widget/app_theme.dart';
import 'package:fyp_project/widget/text_field_input.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/utils/utils.dart';

class PersonalDetail extends StatefulWidget {
  const PersonalDetail({super.key});

  @override
  State<PersonalDetail> createState() => _PersonalDetailState();
}

class _PersonalDetailState extends State<PersonalDetail> {
  bool isLoading = false;
  var userData = {};
  var tourGuideData = {};

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _icNumberController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

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
      _usernameController = TextEditingController(text: userData["username"]);
      _fullnameController = TextEditingController(text: userData["fullname"]);
      _icNumberController = TextEditingController(text: userData["icNumber"].toString());
      _phoneNumberController = TextEditingController(text: userData["phoneNumber"].toString());

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
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          title: const Text('Edit Profile'),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 10),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Text("Username"),
            ),
            TextFieldInput(
              textEditingController: _usernameController,
              hintText: "Username",
              textInputType: TextInputType.text),

            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Text("Full Name"),
            ),
            TextFieldInput(
                textEditingController: _fullnameController,
                hintText: "Full Name",
                textInputType: TextInputType.text),

            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Text("Phone Number"),
            ),
            TextFieldInput(
                textEditingController: _phoneNumberController,
                hintText: "Phone Number",
                textInputType: TextInputType.text),

            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Text("IC Number"),
            ),
            TextFieldInput(
                textEditingController: _icNumberController,
                hintText: "IC Number",
                textInputType: TextInputType.text),

            const SizedBox(height: 10),

          ],
        ),
      );
  }
}