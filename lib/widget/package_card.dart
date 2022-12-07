import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/ui_view/package_detail_view.dart';
import 'package:fyp_project/widget/image_full_screen.dart';
import 'package:intl/intl.dart';

class PackageCard extends StatefulWidget {
  final snap;
  final int index;
  const PackageCard({
    Key? key,
    required this.snap,
    required this.index,
  }) : super(key: key);

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  @override
  void initState() {
    super.initState();
  }

  final DateFormat formatter = DateFormat('dd MMM y');

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery. of(context). size. width;

    return Container(
      height: 140,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: widget.index % 2 == 0 ?
        Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.tertiaryContainer,
      ),
      child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PackageDetail(
                packageDetailSnap: widget.snap,
              ),
            ),
          ),
        child: Row(
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
              child: Image(
                width: 140,
                height: 140,
                image: NetworkImage( widget.snap["photoUrl"]),
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
            const SizedBox(width: 10),
            Container(
              width: width - 170,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  Text(
                    widget.snap["packageTitle"],
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.snap["content"],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 14,
                      ),
                      maxLines: 4,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(formatter.format(widget.snap["createDate"].toDate())),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
