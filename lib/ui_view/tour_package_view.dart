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
  bool isDescending = true;

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
          title: "My Tour Packages"
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Divider(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: addPackage,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Add",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Icon(
                              Icons.add_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],

                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        isDescending = !isDescending;
                      }),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isDescending ? "Latest on Top" : "Earliest on Top",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Icon(
                              isDescending ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],

                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
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
            SizedBox(height: 10,),
            StreamBuilder(
              stream: tourPackagesCollection
                  .orderBy('createDate', descending: isDescending)
                  .snapshots(),
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
                return Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    child: ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (ctx, index) =>
                          Container(
                            child: PackageCard(
                              snap: documents[index].data(),
                              index: index,
                            ),
                          ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
