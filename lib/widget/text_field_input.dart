import 'package:flutter/material.dart';
import 'package:fyp_project/utils/app_theme.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final bool isReadOnly;
  final String hintText;
  final TextInputType textInputType;
  final IconData iconData;

  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    this.isReadOnly = false,
    this.iconData = Icons.import_contacts_sharp,
    required this.hintText,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: hintText,
          prefixIcon: iconData != Icons.import_contacts_sharp ? Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Icon(iconData),
          )  : null,
        ),
        obscureText: isPass,
        enabled: !isReadOnly,
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25.0),
      padding: iconData != Icons.import_contacts_sharp ? const EdgeInsets.symmetric(horizontal: 5.0) : const EdgeInsets.symmetric(horizontal: 20.0),
      width: MediaQuery. of(context).size.width,
      decoration: BoxDecoration(
        color: AppTheme.nearlyWhite,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [ AppTheme.boxShadow ],
      ),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          prefixIcon: iconData != Icons.import_contacts_sharp ? Icon(iconData) : null,
          border: InputBorder.none,
          labelText: hintText,
        ),
        obscureText: isPass,
        enabled: !isReadOnly,
      ),
    );
  }
}
