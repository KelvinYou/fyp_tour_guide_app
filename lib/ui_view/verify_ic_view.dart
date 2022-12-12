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
import 'package:fyp_project/widget/dialogs.dart';
import 'package:fyp_project/widget/image_full_screen.dart';
import 'package:fyp_project/widget/loading_view.dart';
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
  int currentStage = 1;

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

  Widget imageViewCard(String title, Uint8List? image) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: [
          Text(
            "Step $currentStage: Upload your $title",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: ColoredButton(
              onPressed: () => selectImg(title),
              childText: "Upload an Image",
              inverseColor: true,
            ),
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              currentStage > 1 ? (
                  ElevatedButton(
                    onPressed: () => setState(() {
                      currentStage--;
                    }),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.arrow_circle_left,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10,),
                        Text(
                          "Previous",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
              ) : (
                  const SizedBox()
              ),
              currentStage < 3 ? (
                  ElevatedButton(
                    onPressed: () => {
                      if (image == null) {
                        showSnackBar(
                          context,
                          'Please select an image',
                        )
                      } else {
                        setState(() {
                          currentStage++;
                        })
                      }
                    },
                    child: Row(
                      children: const [
                        Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Icon(
                          Icons.arrow_circle_right,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
              ) : (
                  const SizedBox()
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget stageAvatar(int num) {
    return CircleAvatar(
      backgroundColor: num < currentStage + 1 ?
      Theme.of(context).colorScheme.primary
          : AppTheme.lightGrey,
      radius: num < currentStage + 1 ? 15 : 12,
      child: Text(
        num.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: num < currentStage + 1 ? 15 : 12,
        ),
      ),
    );
  }

  Widget showImg(String title, String imgUrl) {
    return Column(
      children: [
        Text(title),
        GestureDetector(
          child: Hero(
            tag: 'imageHero',
            child: Image(
              height: 200,
              fit: BoxFit.fitHeight,
              width: double.infinity,
              // width: double.infinity - 20,
              image: NetworkImage( imgUrl),
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
              return ImageFullScreen(imageUrl: imgUrl,);
            }));
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
          title: "IC Verification"
      ),
      body: isLoading ? LoadingView() : Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
          child: status == "" ? Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    stageAvatar(1),
                    Icon(
                      Icons.keyboard_double_arrow_right,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    stageAvatar(2),
                    Icon(
                      Icons.keyboard_double_arrow_right,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    stageAvatar(3),
                  ],
                ),
              ),

              const SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: currentStage == 1 ? (
                  imageViewCard(frontIcTitle, _frontImage)
                ) : currentStage == 2 ? (
                  imageViewCard(backIcTitle, _backImage)
                ) :  imageViewCard(holdIcTitle, _holdImage),

              ),

              const SizedBox(height: 20.0),

              currentStage == 3 ? (
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: ColoredButton(
                    onPressed: updateImage,
                    childText: "Submit",
                  ),
                )

              ) : (
                const SizedBox()
              ),
            ],
          ) : Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: status == "Pending" ? (
                    Text("Your IC Verification submittion is pending for review.\n"
                        "Please wait for about 3 working days.")
                ) : (
                    Text("Your IC has been verified")
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(),
              ),

              showImg(frontIcTitle, icData["icFrontPic"]),
              const SizedBox(height: 20),
              showImg(backIcTitle, icData["icBackPic"]),
              const SizedBox(height: 20),
              showImg(holdIcTitle, icData["icHoldPic"]),
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