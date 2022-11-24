import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/bottom_bar_view.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/widget/app_theme.dart';
import 'package:image_picker/image_picker.dart';

class VerifyIcView extends StatefulWidget {
  const VerifyIcView({super.key});

  @override
  State<VerifyIcView> createState() => _VerifyIcViewState();
}

class _VerifyIcViewState extends State<VerifyIcView> {
  bool isLoading = false;
  Uint8List? _frontImage, _backImage, _holdImage;



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
      type == "IC Front" ?
        _frontImage = im : type == "IC Back" ?
          _backImage = im : _holdImage = im;
    });
  }

  Widget imageCard(String title) {
    return GestureDetector(
      onTap: () => selectImg(title),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            children: [
              Text(title),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                child: title == "IC Front" ? _frontImage != null ? Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(_frontImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ) : Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/erza.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: null /* add child content here */,
                ) : title == "IC Back" ? _backImage != null ? Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(_backImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ) : Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/erza.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: null /* add child content here */,
                ) : _holdImage != null ? Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(_holdImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ) : Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/erza.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: null /* add child content here */,
                ),
              ),
            ],
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Two-Factor Authentication'),
      ),
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0),
            Text("IC Verification"),
            imageCard("IC Front"),
            imageCard("IC Back"),
            imageCard("IC Hold"),
            ElevatedButton(onPressed: updateImage, child: Text("Update")),
          ],
        ),
      ),
    );
  }

}