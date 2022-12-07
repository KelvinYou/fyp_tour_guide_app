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
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';



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
  String? _currentAddress;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    getData();
    _getCurrentPosition();
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
      _currentPosition!.longitude,
      _currentPosition!.latitude,
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

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
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
            Text('ADDRESS: ${_currentAddress ?? ""}'),
            const SizedBox(height: 32),
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
