import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/bottom_bar_view.dart';
import 'package:fyp_project/resources/firestore_methods.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/colored_button.dart';
import 'package:fyp_project/widget/dialogs.dart';
import 'package:fyp_project/widget/image_full_screen.dart';
import 'package:fyp_project/widget/loading_view.dart';
import 'package:fyp_project/widget/memory_image_full_screen.dart';
import 'package:image_picker/image_picker.dart';

class LicenceView extends StatefulWidget {
  const LicenceView({super.key});

  @override
  State<LicenceView> createState() => _LicenceViewState();
}



class _LicenceViewState extends State<LicenceView> {
  bool isLoading = false;
  var licenceData = {};
  String status = "";
  Uint8List? _licenceImage;

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
      var licenceSnap = await FirebaseFirestore.instance
          .collection('licences')
          .doc("licence_${FirebaseAuth.instance.currentUser!.uid}")
          .get();

      if (licenceSnap.exists) {
        licenceData = licenceSnap.data()!;

        setState(() {
          status = licenceSnap.data()!["status"];
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
      String res = await FireStoreMethods().updateLicence(
        FirebaseAuth.instance.currentUser!.uid,
        _licenceImage
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Submitted!',
        );
        Navigator.of(context).pop();
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

  deleteSubmittion() async {
    setState(() {
      isLoading = true;
    });

    try {
      String res = await FireStoreMethods().deleteLicence(
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
        Navigator.of(context).pop();

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

  selectImg(String type) async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _licenceImage = im;
    });
  }

  Widget imageViewCard(String title, Uint8List? image) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              "Upload your tour guide licence",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: ColoredButton(
              onPressed: () => selectImg(title),
              childText: "Upload an Image",
              inverseColor: true,
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
                image: AssetImage("assets/Badge.jpeg"),
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
    return Scaffold(
      appBar: const SecondaryAppBar(
          title: "Licence"
      ),
      body: isLoading ? LoadingView() : Container(
        height: double.infinity,
        decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: SingleChildScrollView(
        child: status == "" ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Divider(),
            ),
            imageViewCard("Tour Licence Verification", _licenceImage),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: ColoredButton(
                onPressed: updateImage,
                childText: "Submit",
              ),
            )
          ],
        ) : Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Divider(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: status == "Pending" ? (
                  Text("Your Licence Verification submittion is pending for review.\n"
                      "Please wait for about 3 working days.")
              ) : (
                  Text("Your license has been verified")
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Divider(),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              child: Hero(
                tag: 'imageHero',
                child: Image(
                  height: 200,
                  fit: BoxFit.fitHeight,
                  width: double.infinity,
                  // width: double.infinity - 20,
                  image: NetworkImage( licenceData["licencePhotoUrl"]),
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return ImageFullScreen(imageUrl: licenceData["licencePhotoUrl"],);
                }));
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: ColoredButton(
                onPressed: () async {
                  final action = await Dialogs.yesAbortDialog(
                      context, 'Confirm to delete? \nAfter deletion, you can resubmit if necessary', '',
                      'Delete');
                  if (action == DialogAction.yes) {
                    deleteSubmittion();
                  }
                },
                childText: "Delete",
                inverseColor: true,
              )
            ),
            const SizedBox(height: 20),
          ],
        ),
        ),
      ),
    );
  }

}