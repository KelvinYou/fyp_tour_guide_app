import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/resources/firestore_methods.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/text_field_input.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/utils/utils.dart';

class GuideDetail extends StatefulWidget {
  const GuideDetail({super.key});

  @override
  State<GuideDetail> createState() => _GuideDetailState();
}

class _GuideDetailState extends State<GuideDetail> {
  bool isLoading = false;
  var userData = {};
  var tourGuideData = {};
  Uint8List? _image;

  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _languageController = TextEditingController();

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
      _descriptionController = TextEditingController(text: userData["description"]);
      _languageController = TextEditingController(text: userData["language"]);

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
      String res = await FireStoreMethods().updateGuideDetail(
        FirebaseAuth.instance.currentUser!.uid,
        _descriptionController.text,
        _languageController.text,
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
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Edit Profile'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: Text("Description"),
          ),
          TextFieldInput(
              textEditingController: _descriptionController,
              hintText: "Description",
              textInputType: TextInputType.text),

          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: Text("Language"),
          ),
          TextFieldInput(
              textEditingController: _languageController,
              hintText: "Language",
              textInputType: TextInputType.text),

          const SizedBox(height: 10),
          ElevatedButton(onPressed: updateProfile, child: Text("Update"))
        ],
      ),
    );
  }
}