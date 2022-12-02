import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/utils/app_theme.dart';

import 'package:fyp_project/providers/user_provider.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/text_field_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:fyp_project/resources/firestore_methods.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:numberpicker/numberpicker.dart';


class AddPackage extends StatefulWidget {
  const AddPackage({super.key});

  @override
  State<AddPackage> createState() => _AddPackageState();
}

class _AddPackageState extends State<AddPackage> {
  final packageTitleController = TextEditingController();
  final contentController = TextEditingController();
  bool isLoading = false;
  int _currentDuration = 1;
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
        _currentDuration,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Added!',
        );
        Navigator.of(context).pop();
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

  MultiSelectCard<String> customMultiCard(String title) {
    return MultiSelectCard(
      value: title,
      label: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: SecondaryAppBar(
          title: "Add Package"
      ),
      body: GestureDetector(
        onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
        // width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
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
                        child: Text('Duration'),
                      ),
                      Center(
                        child: NumberPicker(
                          value: _currentDuration,
                          minValue: 1,
                          maxValue: 10,
                          step: 1,
                          itemHeight: 50,
                          axis: Axis.horizontal,
                          onChanged: (value) =>
                              setState(() => _currentDuration = value),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black26),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => setState(() {
                              final newValue = _currentDuration - 1;
                              _currentDuration = newValue.clamp(1, 10);
                            }),
                          ),
                          Text('$_currentDuration Days'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => setState(() {
                              final newValue = _currentDuration + 1;
                              _currentDuration = newValue.clamp(1, 10);
                            }),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10.0,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text('Package Type'),
                      ),
                      const SizedBox(height: 10.0,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: MultiSelectContainer(
                          textStyles: MultiSelectTextStyles(
                              textStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary)),
                          itemsDecoration: MultiSelectDecorations(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                  Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                                ]),
                                borderRadius: BorderRadius.circular(10)),
                            selectedDecoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.secondary,
                                ]),
                                borderRadius: BorderRadius.circular(10)),
                            disabledDecoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          maxSelectableCount: 5,
                          items: [
                            customMultiCard('Relax'),
                            customMultiCard('Indoor'),
                            customMultiCard('Adventure'),
                            customMultiCard('Nature'),
                            customMultiCard('Outdoor'),
                            customMultiCard('Budget'),
                            customMultiCard('Culture'),
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
                      const SizedBox(height: 20.0,),
                      GestureDetector(
                        onTap: selectImage,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            // color: AppTheme.lightGrey,
                              border: Border.all(color: Colors.blueAccent, width: 2.0)
                          ),
                          child: _image != null
                              ? Image(
                            width: double.infinity - 20,
                            image: MemoryImage(_image!),
                          )
                          : Column(
                            children: [
                              Text("Select an image"),
                              Image(
                                width: double.infinity / 2,
                                image: AssetImage('assets/add-image.png'),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => submit(
                              FirebaseAuth.instance.currentUser!.uid
                            // userProvider.getUser.uid,
                          ),
                          child: Text("Submit"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}