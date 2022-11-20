import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/widget/app_theme.dart';

import 'package:fyp_project/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPackage extends StatefulWidget {
  const AddPackage({super.key});

  @override
  State<AddPackage> createState() => _AddPackageState();
}

class _AddPackageState extends State<AddPackage> {
  final packageTypeController = TextEditingController();
  final contentController = TextEditingController();
  bool isLoading = false;
  int duration = 3;

  void submit(String uid) async {
    setState(() {
      isLoading = true;
    });

    try {
      String res = await FireStoreMethods().addPackage(
        uid,
        contentController.text,
        packageTypeController.text,
        duration,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
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

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Add Package'),
      ),
      body: ListView(
        children: [
          TextField(
            controller: packageTypeController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Package Type',
            ),
          ),
          TextField(
            controller: contentController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Content',
            ),
          ),
          ElevatedButton(
            onPressed: () => submit(
              FirebaseAuth.instance.currentUser!.uid
              // userProvider.getUser.uid,
            ),
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

}