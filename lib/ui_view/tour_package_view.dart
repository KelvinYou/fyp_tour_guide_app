import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fyp_project/widget/app_theme.dart';

import 'package:fyp_project/ui_view/add_package_view.dart';
import 'package:fyp_project/widget/package_card.dart';

class TourPackage extends StatefulWidget {
  const TourPackage({super.key});

  @override
  State<TourPackage> createState() => _TourPackageState();
}

class _TourPackageState extends State<TourPackage> {
  TextEditingController _searchController = TextEditingController();
  bool ownedOnly = false;

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
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Tour Package'),
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
                    // .toLowerCase()
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
          return Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              ElevatedButton(
                onPressed: addPackage,
                style: ElevatedButton.styleFrom(
                  primary: AppTheme.nearlyWhite,
                  side: const BorderSide(
                    width: 1.0,
                    color: AppTheme.primary,
                  ),
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: AppTheme.primary,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => setState(() {
                  ownedOnly = !ownedOnly;
                }),
                style: ElevatedButton.styleFrom(
                  primary: AppTheme.nearlyWhite,
                  side: const BorderSide(width: 1.0, color: AppTheme.primary,),
                ),
                child: Text(
                  ownedOnly ? "Show all"  : "Only Show My Packages",
                  style: TextStyle(
                    color: AppTheme.primary,
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                    height: 200.0,
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
          );
        },
      ),
    );
  }
}
