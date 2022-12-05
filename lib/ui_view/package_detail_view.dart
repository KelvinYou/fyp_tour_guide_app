import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/ui_view/share_to_view.dart';
import 'package:fyp_project/ui_view/tour_package_view.dart';
import 'package:fyp_project/utils/utils.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/colored_button.dart';
import 'package:intl/intl.dart';
import 'package:fyp_project/widget/image_full_screen.dart';

class PackageDetail extends StatefulWidget {
  final packageDetailSnap;
  const PackageDetail({super.key, required this.packageDetailSnap});

  @override
  State<PackageDetail> createState() => _PackageDetailState();
}

class _PackageDetailState extends State<PackageDetail> {
  bool isLoading = false;
  List<String> selectedTypes = [];

  delete() async {
    setState(() {
      isLoading = true;
    });

    String res = await FireStoreMethods().deletePackage(widget.packageDetailSnap["packageId"]);

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
      showSnackBar(context, "Package removed successfully");
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  Widget getTextWidgets(List<String> strings)
  {
    List<Widget> list = <Widget>[];
    for(var i = 0; i < strings.length; i++){
      list.add(new Text(strings[i]));
    }
    return new Row(children: list);
  }

  final DateFormat formatter = DateFormat('dd MMM, H:mm');

  share() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShareToView(snap: widget.packageDetailSnap),
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
        title: widget.packageDetailSnap["packageTitle"],
        rightButton: Icons.share_outlined,
        function: share,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Container(
                // margin: EdgeInsets.symmetric(horizontal: 25.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: GestureDetector(
                  child: Hero(
                    tag: 'imageHero',
                    child: Image(
                      height: 300,
                      width: double.infinity,
                      // width: double.infinity - 20,
                      image: NetworkImage( widget.packageDetailSnap["photoUrl"]),
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
                      return ImageFullScreen(imageUrl: widget.packageDetailSnap["photoUrl"],);
                    }));
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text("Content:"),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25.0),
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 0),
                child: Text(
                  " ${widget.packageDetailSnap["content"]}",
                  maxLines: null,
                  style: TextStyle(

                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 25.0),
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                child: Text("Type: ${
                    widget.packageDetailSnap["packageType"]
                        .reduce((value, element) => value + ', ' + element)
                }"),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text("Duration: ${widget.packageDetailSnap["duration"].toString()} days"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text("Create Date: ${formatter.format(widget.packageDetailSnap["createDate"].toDate())}"),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: ColoredButton(
                  onPressed: delete,
                  childText: "Delete",
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
