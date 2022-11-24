import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/widget/app_theme.dart';

class VerifyIcView extends StatefulWidget {
  const VerifyIcView({super.key});

  @override
  State<VerifyIcView> createState() => _VerifyIcViewState();
}

class _VerifyIcViewState extends State<VerifyIcView> {
  bool isLoading = false;

  Widget imageCard(String title) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: [
            Text(title),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
              child: Container(
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
    );
  }

  updateImage() async {

  }

  selectFrontImg() async {
    print("object");
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
            GestureDetector(
              onTap: selectFrontImg,
              child: imageCard("IC Front"),
            ),
            imageCard("IC Back"),
            imageCard("IC Hold"),
            ElevatedButton(onPressed: updateImage, child: Text("Update")),
          ],
        ),
      ),
    );
  }

}