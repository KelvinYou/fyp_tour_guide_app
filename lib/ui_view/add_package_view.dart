import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/utils/app_theme.dart';

import 'package:fyp_project/providers/user_provider.dart';
import 'package:fyp_project/widget/text_field_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';



class AddPackage extends StatefulWidget {
  const AddPackage({super.key});

  @override
  State<AddPackage> createState() => _AddPackageState();
}

class _AddPackageState extends State<AddPackage> {
  final packageTitleController = TextEditingController();
  final contentController = TextEditingController();
  bool isLoading = false;
  int duration = 3;
  List<String> selectedTypes = [];
  Uint8List? _image;

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  void submit(String uid) async {
    setState(() {
      isLoading = true;
    });

    try {
      String res = await FireStoreMethods().addPackage(
        uid,
        packageTitleController.text,
        contentController.text,
        selectedTypes,
        _image,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 9,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30.0,),
                  TextFieldInput(
                      textEditingController: packageTitleController,
                      hintText: "Package Title",
                      textInputType: TextInputType.text,
                      iconData: Icons.backpack_outlined),
                  const SizedBox(height: 20.0,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text('Package Type'),
                  ),
                  const SizedBox(height: 10.0,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: MultiSelectContainer(
                      maxSelectableCount: 5,
                      items: [
                        MultiSelectCard(value: 'Relax', label: 'Relax'),
                        MultiSelectCard(value: 'Outdoor', label: 'Outdoor'),
                        MultiSelectCard(value: 'Indoor', label: 'Indoor'),
                        MultiSelectCard(value: 'Advanture', label: 'Adventure'),
                        MultiSelectCard(value: 'Nature', label: 'Nature'),
                        MultiSelectCard(value: 'Budget', label: 'Budget'),
                        MultiSelectCard(value: 'Culture', label: 'Culture'),
                      ],
                      onMaximumSelected: (allSelectedItems, selectedItem) {
                        showSnackBar(
                          context,
                          'The limit has been reached',
                        );
                      },
                      onChange: (allSelectedItems, selectedItem) {
                        print(allSelectedItems);
                        setState(() {
                          selectedTypes = allSelectedItems;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 20.0,),
                  TextFieldInput(
                      textEditingController: contentController,
                      hintText: "Content",
                      textInputType: TextInputType.multiline,
                      maxLines: null),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20.0,),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: ElevatedButton(
                onPressed: () => submit(
                    FirebaseAuth.instance.currentUser!.uid
                  // userProvider.getUser.uid,
                ),
                child: const Text("Submit"),
              ),
            ),
          ),
          const SizedBox(height: 20.0,),
        ],
      ),
    );
  }

}