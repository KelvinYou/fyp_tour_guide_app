import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:fyp_project/widget/app_theme.dart';
import 'package:fyp_project/ui_view/package_detail_view.dart';

class PackageCard extends StatefulWidget {
  final snap;
  const PackageCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      decoration: BoxDecoration(
        color: AppTheme.nearlyWhite,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [ AppTheme.boxShadow ],
      ),
      child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PackageDetail(
                packageDetailSnap: widget.snap,
              ),
            ),
          ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
          child: Column(
            children: [
              Text(widget.snap["packageTitle"]),
              const SizedBox(height: 10.0),
              Text(widget.snap["content"]),
            ],
          ),
        ),
      ),
    );
  }
}
