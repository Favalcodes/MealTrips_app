import 'package:flutter/material.dart';
import 'package:mealtrips/fooddel/components/default_buttons.dart';
import 'package:mealtrips/size_config.dart';

class AddDeliveryTime extends StatelessWidget {

  final TextEditingController textController = TextEditingController();

  void setDeliveryTime(BuildContext context) {
    Navigator.pop(context, textController.text);
    SnackBar snackBar = SnackBar(content: Text("Delivery time set."));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Estimated Delivery Time',
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontWeight: FontWeight.w400,
            fontSize: SizeConfig.screenWidth * 0.04,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).textSelectionColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                child: Column(
                  children: [
                    buildFormField(context),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              DefaultButton(
                press: () => setDeliveryTime(context),
                text: 'Set Time',
              )
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: textController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Delivery time',
        suffixIcon: Icon(Icons.label),
        labelText: 'time(minutes)',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Theme.of(context).hintColor),
            gapPadding: 0),
        focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Theme.of(context).textSelectionColor),
            gapPadding: 0),
        errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(20)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
      ),
    );
  }
}
