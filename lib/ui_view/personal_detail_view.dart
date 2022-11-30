import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/resources/firestore_methods.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/colored_button.dart';
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
  Uint8List? _image;

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
      _icNumberController = TextEditingController(text: userData["icNumber"]);
      _phoneNumberController = TextEditingController(text: userData["phoneNumber"]);

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

  updateProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      String res = await FireStoreMethods().updatePersonalDetail(
        FirebaseAuth.instance.currentUser!.uid,
        _usernameController.text,
        _fullnameController.text,
        _icNumberController.text,
        _phoneNumberController.text,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Updated!',
        );
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
      ? const Center(
        child: CircularProgressIndicator(),
      )
      : Scaffold(
        appBar: SecondaryAppBar(
            title: "Edit Profile"
        ),
        body: Container(
          // width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextFieldInput(
                    textEditingController: _usernameController,
                    hintText: "Username",
                    textInputType: TextInputType.text),

                const SizedBox(height: 20),
                TextFieldInput(
                    textEditingController: _fullnameController,
                    hintText: "Full Name",
                    textInputType: TextInputType.text),

                const SizedBox(height: 20),
                TextFieldInput(
                    textEditingController: _phoneNumberController,
                    hintText: "Phone Number",
                    textInputType: TextInputType.text),

                const SizedBox(height: 20),
                TextFieldInput(
                    textEditingController: _icNumberController,
                    hintText: "IC Number",
                    textInputType: TextInputType.text),

                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: ColoredButton(
                      onPressed: updateProfile,
                      childText: "Update"),),
              ],
            ),
          ),
        ),
      );
  }
}