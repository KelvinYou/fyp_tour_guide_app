import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/bottom_bar_view.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/colored_button.dart';
import 'package:fyp_project/widget/image_full_screen.dart';
import 'package:fyp_project/widget/memory_image_full_screen.dart';
import 'package:image_picker/image_picker.dart';

class VerifyIcView extends StatefulWidget {
  const VerifyIcView({super.key});

  @override
  State<VerifyIcView> createState() => _VerifyIcViewState();
}

class _VerifyIcViewState extends State<VerifyIcView> {
  bool isLoading = false;
  Uint8List? _frontImage, _backImage, _holdImage;
  String frontIcTitle = "IC Front";
  String backIcTitle = "IC Back";
  String holdIcTitle = "IC Hold";
  String status = "";
  var icData = {};

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
      var icSnap = await FirebaseFirestore.instance
          .collection('icVerifications')
          .doc("ic_${FirebaseAuth.instance.currentUser!.uid}")
          .get();

      if (icSnap.exists) {
        icData = icSnap.data()!;

        setState(() {
          status = icSnap.data()!["status"];
        });
      }
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

  updateImage() async {
    setState(() {
      isLoading = true;
    });

    try {
      String res = await FireStoreMethods().updateVerifyIC(
        FirebaseAuth.instance.currentUser!.uid,
        _frontImage, _backImage, _holdImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Submitted!',
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

  selectImg(String type) async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      type == frontIcTitle ?
        _frontImage = im : type == backIcTitle ?
          _backImage = im : _holdImage = im;
    });
  }

  deleteSubmittion() async {
    setState(() {
      isLoading = true;
    });

    try {
      String res = await FireStoreMethods().deleteVerifyIC(
        FirebaseAuth.instance.currentUser!.uid,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Deleted!',
        );
      } else {
        showSnackBar(context, res);
        setState(() {
          isLoading = false;
        });
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

  Widget imageViewCard(String title, Uint8List? image) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextButton(
              onPressed: () => selectImg(title),
              child: Text(
                "Upload an Image",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
          ),

          image != null ? GestureDetector(
            child: Container(
              height: 200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white),
                image: DecorationImage(
                  image: MemoryImage(image!),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return MemoryImageFullScreen(image: image,);
              }));
            },
          ) : Container(
            height: 200.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/${
                    title == frontIcTitle ? "ic_front" :
                        title == backIcTitle ? "ic_back" : "ic_hold"
                }.jpg"),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: null /* add child content here */,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: SecondaryAppBar(
          title: "IC Verification"
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
          child: status == "" ? Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
              imageViewCard(frontIcTitle, _frontImage),
              imageViewCard(backIcTitle, _backImage),
              imageViewCard(holdIcTitle, _holdImage),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: ColoredButton(
                  onPressed: updateImage,
                  childText: "Submit",
                ),
              ),
            ],
          ) : Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              status == "Pending" ? (
                Text("Your IC Verification submittion is pending for review.\n"
                    "Please wait for about 3 working days.")
              ) : (
                Text("Your IC have been verify")
              ),

              const SizedBox(height: 10.0),
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      icData["icFrontPic"],
                    ),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      icData["icBackPic"],
                    ),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      icData["icHoldPic"],
                    ),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              IconButton(
                  onPressed: deleteSubmittion,
                  icon: Icon(Icons.delete_outline_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }

}