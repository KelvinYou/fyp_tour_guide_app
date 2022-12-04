import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/bottom_bar_view.dart';

import 'package:fyp_project/utils/app_theme.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/colored_button.dart';

import 'package:fyp_project/widget/text_field_input.dart';



class InstantOrder extends StatefulWidget {
  const InstantOrder({super.key});

  @override
  State<InstantOrder> createState() => _InstantOrderState();
}

class _InstantOrderState extends State<InstantOrder> {
  TextEditingController _priceController = TextEditingController();
  var instantOrderData = {};
  String priceErrorMsg = "";
  bool isOnDuty = false;
  // bool isReadOnly = true;
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

    res = await FireStoreMethods().updateOrder(
      FirebaseAuth.instance.currentUser!.uid,
      int.parse(_priceController.text),
      isOnDuty,
    );
    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const BottomBarView(selectedIndex: 0),
        ),
      );
      showSnackBar(
        context,
        'Update Successfully!',
      );
    } else {
      showSnackBar(context, res);
    }
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
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(),
              ),
              SizedBox(height: 10.0,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "On duty",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Switch(
                      value: isOnDuty,
                      onChanged: (value) {
                        setState(() {
                          isOnDuty = value;
                          print(isOnDuty);
                        });
                      },
                      activeTrackColor: Colors.lightBlueAccent,
                      activeColor: AppTheme.primary,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              TextFieldInput(
                textEditingController: _priceController,
                // isReadOnly: isReadOnly,
                hintText: "Price",
                textInputType: TextInputType.number,
                errorMsg: priceErrorMsg,),
              SizedBox(height: 20.0,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: ColoredButton(
                  onPressed: edit,
                  childText: "Update",
                ),
              ),
            ],
          ),
        ),
      );
  }
}