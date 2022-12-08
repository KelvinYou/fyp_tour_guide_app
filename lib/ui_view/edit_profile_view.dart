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

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  bool isLoading = false;
  var userData = {};
  var tourGuideData = {};
  String usernameErrorMsg = "";
  String fullnameErrorMsg = "";
  String phoneNumberErrorMsg = "";
  String icNumberErrorMsg = "";
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
      _icNumberController = TextEditingController(text:
      userData["icNumber"].replaceAll(
          RegExp(r'[^0-9]'), ''));
      _phoneNumberController = TextEditingController(text:
      userData["phoneNumber"].replaceAll(
          RegExp(r'[^0-9]'), ''));

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
      usernameErrorMsg = "";
      fullnameErrorMsg = "";
      phoneNumberErrorMsg = "";
      icNumberErrorMsg = "";
    });

    bool usernameFormatCorrected = false;
    bool fullnameFormatCorrected = false;
    bool phoneNumberFormatCorrected = false;
    bool icNumberFormatCorrected = false;

    if (_usernameController.text == "") {
      setState(() {
        usernameErrorMsg = "The Username cannot be empty.";
      });
    } else {
      usernameFormatCorrected = true;
    }

    if (_fullnameController.text == "") {
      setState(() {
        fullnameErrorMsg = "The Full Name cannot be empty.";
      });
    } else {
      fullnameFormatCorrected = true;
    }

    String phoneNumberOnlyNum = _phoneNumberController.text.replaceAll(
        RegExp(r'[^0-9]'), '');
    String formattedPhoneNumber = "";

    if (_phoneNumberController.text != "") {
      if (
        ((phoneNumberOnlyNum.length == 10
        || phoneNumberOnlyNum.length == 11)
        && phoneNumberOnlyNum.startsWith("0")) ||
        ((phoneNumberOnlyNum.length == 12
        || phoneNumberOnlyNum.length == 13)
        && phoneNumberOnlyNum.startsWith("6"))
    ) {
        if (phoneNumberOnlyNum.startsWith("6")) {
          formattedPhoneNumber = 
          "+(${phoneNumberOnlyNum.substring(0,2)}) ${phoneNumberOnlyNum.substring(2, 4)}-${phoneNumberOnlyNum.substring(4, 8)} ${phoneNumberOnlyNum.substring(8)}";
        } else {
          formattedPhoneNumber =
          "+(6${phoneNumberOnlyNum.substring(0,1)}) ${phoneNumberOnlyNum.substring(1, 3)}-${phoneNumberOnlyNum.substring(3, 7)} ${phoneNumberOnlyNum.substring(7)}";
        }
        phoneNumberFormatCorrected = true;
      } else {
        setState(() {
          phoneNumberErrorMsg = "Incorrect Phone Number Format.\n"
              "E.g. The correct phone number format is as follows: "
              "0123456789 / 60123456789";
        });
      }
    } else {
      phoneNumberFormatCorrected = true;
    }

    String icOnlyNum = _icNumberController.text.replaceAll(
        RegExp(r'[^0-9]'), '');
    String formattedIcNumber = "";

    if (_icNumberController.text != "") {
      if (icOnlyNum.length == 12) {
        formattedIcNumber =
        "${icOnlyNum.substring(0, 6)}-${icOnlyNum.substring(6, 8)}-${icOnlyNum.substring(8)}";
        icNumberFormatCorrected = true;
      } else {
        setState(() {
          icNumberErrorMsg = "Incorrect IC Number Format.\n"
              "E.g. The correct ic number format is as follows: "
              "981020103456 / 981020-10-3456";
        });
      }
    } else {
      icNumberFormatCorrected = true;
    }

    if (
      usernameFormatCorrected && fullnameFormatCorrected
      && phoneNumberFormatCorrected && icNumberFormatCorrected
    ) {
      try {
        String res = await FireStoreMethods().updatePersonalDetail(
          FirebaseAuth.instance.currentUser!.uid,
          _usernameController.text,
          _fullnameController.text,
          formattedIcNumber,
          formattedPhoneNumber,
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
                  textInputType: TextInputType.text,
                  errorMsg: usernameErrorMsg,
                ),

                const SizedBox(height: 20),
                TextFieldInput(
                  textEditingController: _fullnameController,
                  hintText: "Full Name",
                  textInputType: TextInputType.text,
                  errorMsg: fullnameErrorMsg,
                ),

                const SizedBox(height: 20),
                TextFieldInput(
                  textEditingController: _phoneNumberController,
                  hintText: "Phone Number",
                  textInputType: TextInputType.phone,
                  errorMsg: phoneNumberErrorMsg,
                ),

                const SizedBox(height: 20),
                TextFieldInput(
                  textEditingController: _icNumberController,
                  hintText: "IC Number",
                  textInputType: TextInputType.number,
                  errorMsg: icNumberErrorMsg,
                ),

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
