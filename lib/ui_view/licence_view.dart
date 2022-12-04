import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';

class LicenceView extends StatefulWidget {
  const LicenceView({super.key});

  @override
  State<LicenceView> createState() => _LicenceViewState();
}

class _LicenceViewState extends State<LicenceView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: const SecondaryAppBar(
          title: "Licence"
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


            ],
          ),
        ),
      ),
    );
  }

}