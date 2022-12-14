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
  String cvvNumber = "";
  String expiredDateNumber = "";

  String cardNumberErrorMsg = "";
  String cvvErrorMsg = "";
  String expiredDateErrorMsg = "";

  TextEditingController expiredDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  bool isLoading = false;

  void submit() async {
    setState(() {
      isLoading = true;
      cardNumberErrorMsg = "";
      cvvErrorMsg = "";
      expiredDateErrorMsg = "";
    });

    bool cardNumberFormatCorrected = false;
    bool cvvFormatCorrected = false;
    bool expiredDateFormatCorrected = false;

    if (cardNumber == "") {
      setState(() {
        cardNumberErrorMsg = "This field cannot be empty.";
      });
    } else if (cardNumber.length < 19) {
      setState(() {
        cardNumberErrorMsg = "Please enter the correct card number.";
      });
    } else {
      cardNumberFormatCorrected = true;
    }

    if (cvvNumber == "") {
      setState(() {
        cvvErrorMsg = "This field cannot be empty.";
      });
    } else if (cvvNumber.length < 3) {
      setState(() {
        cvvErrorMsg = "Please enter the correct CVV.";
      });
    } else {
      cvvFormatCorrected = true;
    }

    if (expiredDateNumber == "") {
      setState(() {
        expiredDateErrorMsg = "This field cannot be empty.";
      });
    } else if (expiredDateNumber.length < 5) {
      setState(() {
        expiredDateErrorMsg = "Please enter the correct card's expired date.";

      });
    } else if (int.parse(expiredDateNumber.substring(0, 2)) > 12 ||
        int.parse(expiredDateNumber.substring(0, 2)) < 1) {
      setState(() {
        expiredDateErrorMsg = "Invalid month.";

      });
    } else {
      expiredDateFormatCorrected = true;
    }

    if (cardNumberFormatCorrected && cvvFormatCorrected && expiredDateFormatCorrected) {
      try {
        String res = await FireStoreMethods().addBankCard(
          FirebaseAuth.instance.currentUser!.uid,
          cardNumber,
          cvvNumber,
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
              : Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                cardNumberErrorMsg,
                style: TextStyle(
                  color: AppTheme.errorRed,
                ),
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
                            labelText: 'CVV',
                            counterText: "",
                          ),
                          maxLength: 3,
                          onChanged: (value) {
                            setState(() {
                              cvvNumber = value;
                            });
                          },
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

                ],
              ),

            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: cvvErrorMsg == "" ?
                    SizedBox()
                        : Text(
                      cvvErrorMsg,
                      style: TextStyle(
                        color: AppTheme.errorRed,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: expiredDateErrorMsg == "" ?
                    SizedBox()
                        : Text(
                      expiredDateErrorMsg,
                      style: TextStyle(
                        color: AppTheme.errorRed,
                      ),
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