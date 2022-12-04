import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/resources/firestore_methods.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/text_field_input.dart';
import 'package:fyp_project/widget/colored_button.dart';

class AddBankCardView extends StatefulWidget {
  const AddBankCardView({super.key});

  @override
  State<AddBankCardView> createState() => _AddBankCardViewState();
}

class _AddBankCardViewState extends State<AddBankCardView> {
  String cardNumber = "";
  String ccvNumber = "";
  String expiredDateNumber = "";

  String cardNumberErrorMsg = "";
  String ccvErrorMsg = "";
  String expiredDateErrorMsg = "";

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
        ccvNumber,
        expiredDateNumber,
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
      appBar: SecondaryAppBar(
          title: "Add New Bank Card"
      ),
      body: Container(
      // width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.background,
      ),
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

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'XXX',
                        labelText: 'Card Number',
                      ),
                      maxLength: 3,
                      onChanged: (value) {
                        setState(() {
                          ccvNumber = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ExpiredDateFormatter(),
                      ],
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'MM/YY',
                        labelText: 'Expired Date',
                      ),
                      maxLength: 5,
                      onChanged: (value) {
                        setState(() {
                          expiredDateNumber = value;
                        });
                      },
                    ),
                  ),

                ],
              ),

            ),

            const SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: ColoredButton(
                  childText: "Submit",
                  onPressed: submit
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

}

class ExpiredDateFormatter extends TextInputFormatter {
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
      if (nonZeroIndexValue % 2 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write('/');
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