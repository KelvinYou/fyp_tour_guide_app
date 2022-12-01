import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/ui_view/instant_order_list_view.dart';
import 'package:fyp_project/ui_view/package_booking_list_view.dart';
import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/widget/app_bar/main_app_bar.dart';
import 'package:fyp_project/widget/main_container.dart';

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return isLoading
      ? const Center(
        child: CircularProgressIndicator(),
      ) : Scaffold(
        appBar: MainAppBar(title: "Order"),
        body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
        child: Column(
            children: [
              MainContainer(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const InstantOrderListView(),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text("Hourly Order"),
                          ],
                        ),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                    color: AppTheme.lightGrey,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PackageBookingListView(),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text("Tour Package"),
                          ],
                        ),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                ],
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}