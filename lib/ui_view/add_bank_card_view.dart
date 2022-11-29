import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/resources/firestore_methods.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/widget/text_field_input.dart';

class AddBankCardView extends StatefulWidget {
  const AddBankCardView({super.key});

  @override
  State<AddBankCardView> createState() => _AddBankCardViewState();
}

class _AddBankCardViewState extends State<AddBankCardView> {
  String cardNumber = "";
  TextEditingController expiredDateController = TextEditingController();
  TextEditingController ccvController = TextEditingController();
  bool isLoading = false;

  void submit() async {
    setState(() {
      isLoading = true;
    });

    try {
      String res = await FireStoreMethods().addBankCard(
        FirebaseAuth.instance.currentUser!.uid,
        cardNumber,
        ccvController.text,
        expiredDateController.text,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
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
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: AppBar(
        title: const Text('Add New Bank Card'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30.0,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CardNumberFormatter(),
                      ],
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/800px-Mastercard-logo.svg.png',
                            height: 30,
                            width: 30,
                          ),
                        ),
                        border: OutlineInputBorder(),
                        hintText: 'XXXX XXXX XXXX XXXX',
                        labelText: 'Card Number',
                      ),
                      maxLength: 19,
                      onChanged: (value) {
                        setState(() {
                          cardNumber = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 5,),
                  TextFieldInput(
                    textEditingController: ccvController,
                    hintText: "CCV",
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 25,),
                  TextFieldInput(
                    textEditingController: expiredDateController,
                    hintText: "Expired Date",
                    textInputType: TextInputType.text,
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
                      onPressed: () => submit(),
                      child: Text("Submit"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue previousValue,
      TextEditingValue nextValue,
      ) {
    var inputText = nextValue.text;

    if (nextValue.selection.baseOffset == 0) {
      return nextValue;
    }

    var bufferString = new StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write(' ');
      }
    }

    var string = bufferString.toString();
    return nextValue.copyWith(
      text: string,
      selection: new TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}