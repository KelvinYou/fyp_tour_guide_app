import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/resources/firestore_methods.dart';

import 'package:fyp_project/utils/app_theme.dart';
import 'package:fyp_project/utils/utils.dart';
import 'package:fyp_project/widget/app_bar/secondary_app_bar.dart';
import 'package:fyp_project/widget/loading_view.dart';
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
      cardNumberErrorMsg = "";
      ccvErrorMsg = "";
      expiredDateErrorMsg = "";
    });

    bool cardNumberFormatCorrected = false;
    bool ccvFormatCorrected = false;
    bool expiredDateFormatCorrected = false;

    if (cardNumber == "") {
      setState(() {
        cardNumberErrorMsg = "Please enter your card number.";
      });
    } else if (cardNumber.length < 19) {
      setState(() {
        cardNumberErrorMsg = "Please enter the correct card number.";
      });
    } else {
      cardNumberFormatCorrected = true;
    }

    if (ccvNumber == "") {
      setState(() {
        ccvErrorMsg = "Please enter your card's CCV'.";
      });
    } else if (cardNumber.length < 3) {
      setState(() {
        ccvErrorMsg = "Please enter the correct CCV.";
      });
    } else {
      ccvFormatCorrected = true;
    }

    if (cardNumber == "") {
      setState(() {
        cardNumberErrorMsg = "Please enter your card's expired date.";
      });
    } else if (cardNumber.length < 5) {
      setState(() {
        cardNumberErrorMsg = "Please enter the correct card's expired date.";
      });
    } else {
      expiredDateFormatCorrected = true;
    }

    if (cardNumberFormatCorrected && ccvFormatCorrected && expiredDateFormatCorrected) {
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
            'Added!',
          );
          Navigator.of(context).pop();
        } else {
          showSnackBar(context, res);
        }
      } catch (err) {

        showSnackBar(
          context,
          err.toString(),
        );
      }
    }
    setState(() {
      isLoading = false;
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
          title: "Add New Bank Card"
      ),
      body: isLoading ? LoadingView() : Container(
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
              child: TextField(
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
                  counterText: "",
                ),
                maxLength: 19,
                onChanged: (value) {
                  setState(() {
                    cardNumber = value;
                  });
                },
              ),
            ),
            cardNumberErrorMsg == "" ?
            SizedBox()
                : Text(
              cardNumberErrorMsg,
              style: TextStyle(
                color: AppTheme.errorRed,
              ),
            ),
            const SizedBox(height: 20,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'XXX',
                            labelText: 'CCV',
                            counterText: "",
                          ),
                          maxLength: 3,
                          onChanged: (value) {
                            setState(() {
                              ccvNumber = value;
                            });
                          },
                        ),
                        ccvErrorMsg == "" ?
                        SizedBox()
                            : Text(
                          ccvErrorMsg,
                          style: TextStyle(
                            color: AppTheme.errorRed,
                          ),
                        ),
                      ],
                    )
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: TextField(
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
                        counterText: "",
                      ),
                      maxLength: 5,
                      onChanged: (value) {
                        setState(() {
                          expiredDateNumber = value;
                        });
                      },

                    ),
                  ),
                  expiredDateErrorMsg == "" ?
                  SizedBox()
                      : Text(
                    expiredDateErrorMsg,
                    style: TextStyle(
                      color: AppTheme.errorRed,
                    ),
                  ),
                ],
              ),

            ),

            const SizedBox(height: 20.0),
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