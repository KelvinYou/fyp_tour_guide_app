import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/resources/firestore_methods.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/colored_button.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/text_field_input.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';

class GuideDetail extends StatefulWidget {
  const GuideDetail({super.key});

  @override
  State<GuideDetail> createState() => _GuideDetailState();
}

class _GuideDetailState extends State<GuideDetail> {
  bool isLoading = false;
  var userData = {};
  var tourGuideData = {};
  int malayRtg = 0;
  int englishRtg = 0;
  int mandarinRtg = 0;
  int tamilRtg = 0;

  Uint8List? _image;
  TextEditingController _descriptionController = TextEditingController();

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
      _descriptionController = TextEditingController(text: userData["description"]);

      setState(() {
        malayRtg = userData["language"]["Malay"];
        englishRtg = userData["language"]["English"];
        mandarinRtg = userData["language"]["Mandarin"];
        tamilRtg = userData["language"]["Tamil"];
      });
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
    });

    try {
      String res = await FireStoreMethods().updateGuideDetail(
        FirebaseAuth.instance.currentUser!.uid,
        _descriptionController.text,
        {
          "Malay": malayRtg,
          "Mandarin": mandarinRtg,
          "English": englishRtg,
          "Tamil": tamilRtg,
        },
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

  Widget languageList(String language) {
    double rating = 0;
    if (language == "Malay") {
      rating = malayRtg.toDouble();
    } else if (language == "English") {
      rating = englishRtg.toDouble();
    } else if (language == "Mandarin") {
      rating = mandarinRtg.toDouble();
    } else if (language == "Tamil") {
      rating = tamilRtg.toDouble();
    }

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(language),
        ),
        Expanded(
          flex: 4,
          child: RatingBar.builder(
            initialRating: rating,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 24.0,
            direction: Axis.horizontal,
            onRatingUpdate: (rating) {
              setState(() {
                language == "Malay" ? malayRtg = rating.toInt()
                    : language == "English" ? englishRtg = rating.toInt()
                    : language == "Mandarin" ? mandarinRtg = rating.toInt()
                    : tamilRtg = rating.toInt();
              });
            },
          ),
        ),
        Text(
          rating.toInt().toString(),
          style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onPrimary
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    )
    : Scaffold(
      appBar: SecondaryAppBar(
          title: "Guide Detail"
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  TextFieldInput(
                    textEditingController: _descriptionController,
                    hintText: "Description",
                    textInputType: TextInputType.text,
                    maxLines: null,
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Prefered Language(s)",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        languageList("Malay"),
                        Divider(),
                        languageList("English"),
                        Divider(),
                        languageList("Mandarin"),
                        Divider(),
                        languageList("Tamil"),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                child: ColoredButton(
                    onPressed: updateProfile,
                    childText: "Update"
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}