import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/utils/app_theme.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';

import 'package:fyp_project/widget/text_field_input.dart';



class InstantOrder extends StatefulWidget {
  const InstantOrder({super.key});

  @override
  State<InstantOrder> createState() => _InstantOrderState();
}

class _InstantOrderState extends State<InstantOrder> {
  TextEditingController _priceController = TextEditingController();
  var instantOrderData = {};
  bool isOnDuty = false;
  bool isReadOnly = true;
  bool isLoading = true;

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
      var instantOrderSnap = await FirebaseFirestore.instance
          .collection('instantOrder')
          .doc("instant_${FirebaseAuth.instance.currentUser!.uid}")
          .get();

      instantOrderData = instantOrderSnap.data()!;
      _priceController = TextEditingController(text: instantOrderData["price"].toString());
      isOnDuty = instantOrderData["onDuty"];

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

  void edit() async {
    String res;
    isReadOnly ?
      setState(() {
        isReadOnly = false;
      }) : {
      res = await FireStoreMethods().updateOrder(
        FirebaseAuth.instance.currentUser!.uid,
        int.parse(_priceController.text),
        isOnDuty,
      ),
      if (res == "success") {
        setState(() {
          isLoading = false;
          isReadOnly = true;
        }),
        showSnackBar(
          context,
          'Update Successfully!',
        ),
      } else {
        showSnackBar(context, res)
      }
    };
  }

  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
        child: CircularProgressIndicator(),
      )
      : Scaffold(
        appBar: SecondaryAppBar(
            title: "Hourly Order Detail"
        ),
        body: ListView(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("On duty")),
            Switch(
              value: isOnDuty,
              onChanged: (value) {
                isReadOnly ?
                setState(() {}) : setState(() {
                  isOnDuty = value;
                  print(isOnDuty);
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
            Text("Price Per Hour"),
            TextFieldInput(
                textEditingController: _priceController,
                isReadOnly: isReadOnly,
                hintText: "Price",
                textInputType: TextInputType.number),
            ElevatedButton(
                onPressed: () => edit(),
                child: Text(isReadOnly ? "Edit" : "Save")),
          ],
        ),
      );
  }
}