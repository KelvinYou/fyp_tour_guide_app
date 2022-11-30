import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:fyp_project/utils/app_theme.dart';

import 'package:fyp_project/ui_view/add_package_view.dart';
import 'package:fyp_project/widget/colored_button.dart';
import 'package:fyp_project/widget/package_card.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/text_field_input.dart';



class TourPackage extends StatefulWidget {
  const TourPackage({super.key});

  @override
  State<TourPackage> createState() => _TourPackageState();
}

class _TourPackageState extends State<TourPackage> {
  TextEditingController _searchController = TextEditingController();
  bool ownedOnly = true;

  CollectionReference tourPackagesCollection =
    FirebaseFirestore.instance.collection('tourPackages');
  List<DocumentSnapshot> documents = [];

  String searchText = '';

  void addPackage() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPackage()),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
          title: "Tour Package"
      ),
      body: StreamBuilder(
        stream: tourPackagesCollection.snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.hasData) {
            documents = streamSnapshot.data!.docs;
            //todo Documents list added to filterTitle
            if (searchText.isNotEmpty) {
              documents = documents.where((element) {
                return element
                    .get('packageTitle')
                    .toLowerCase()
                    .contains(searchText.toLowerCase());
              }).toList();
            }
            if (ownedOnly) {
              documents = documents.where((element) {
                return element
                    .get('ownerId')
                    .contains(FirebaseAuth.instance.currentUser!.uid);
              }).toList();
            }
          }
          return Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: ColoredButton(
                        onPressed: addPackage,
                        childText: "Add"
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                    child: const Divider(
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: AppTheme.lightGrey,
                    ),
                  ),

                  TextFieldInput(
                    textEditingController: _searchController,
                    hintText: "Search",
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    textInputType: TextInputType.text,
                    iconData: Icons.search_outlined,
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: Text(
                      "My Tour Packages",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      child: ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (ctx, index) =>
                            Container(
                              child: PackageCard(
                                snap: documents[index].data(),
                              ),
                            ),
                      ),
                    ),
                  ),
                ]
            ),
          );
        },
      ),
    );
  }
}
