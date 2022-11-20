import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/widget/app_theme.dart';

import 'package:image_picker/image_picker.dart';

import 'package:fyp_project/utils/utils.dart';

import 'package:fyp_project/bottom_bar_view.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_project/resources/firestore_methods.dart';



class ChangeProfile extends StatefulWidget {
  const ChangeProfile({super.key});

  @override
  State<ChangeProfile> createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  Uint8List? _image;
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

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  submit() async {
    setState(() {
      isLoading = true;
    });

    try {
      String res = await FireStoreMethods().changeProfile(
        userData["uid"],
        _image,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const BottomBarView(selectedIndex: 4),
          ),
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
      ) : Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Change Profile'),
      ),
      body: Column(
        children: [
          _image != null
              ? CircleAvatar(
            radius: 64,
            backgroundImage: MemoryImage(_image!),
            backgroundColor: Colors.red,
          )
              : CircleAvatar(
            radius: 64,
            backgroundImage: NetworkImage(
                userData["photoUrl"]),
            backgroundColor: Colors.red,
          ),
          IconButton(
            onPressed: selectImage,
            icon: const Icon(Icons.add_a_photo),
          ),
          ElevatedButton(onPressed: submit, child: Text("Done"))
        ],
      ),
    );
  }
}