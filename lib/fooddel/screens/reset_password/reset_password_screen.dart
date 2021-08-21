import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/fooddel/components/default_buttons.dart';
import 'package:mealtrips/fooddel/services/Authentication.dart';
import 'package:mealtrips/size_config.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController emailController = TextEditingController();
  AuthImplementation auth = Auth();
  String userId;
  int catIndex;
  bool additionalField = false;
  bool showLoader = false;

  Future<void> resetPassword(String email) async {
    setState(() => showLoader = true);
    if (email == "") {
      SnackBar snackBar =
          SnackBar(content: Text("Please enter your email address."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      try {
        FirebaseAuth.instance..sendPasswordResetEmail(email: email);
        SnackBar snackBar = SnackBar(
            content: Text(
                "Verification email has been sent to your email address."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Timer(Duration(seconds: 3), () {
          Navigator.pop(context);
        });
      } catch (e) {
        SnackBar snackBar = SnackBar(content: Text(e.message.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    setState(() => showLoader = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: getProportionateScreenHeight(25)),
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      showLoader
                          ? SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.redAccent),
                                strokeWidth: 2.0,
                              ),
                            )
                          : Text(
                              'Reset password',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.screenWidth * 0.07,
                                  color: Theme.of(context).textSelectionColor),
                            ),
                      SizedBox(height: getProportionateScreenHeight(100)),
                      buildEmailFormField(context),
                    ],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(40)),
                DefaultButton(
                  press: () =>
                      resetPassword(emailController.text.toLowerCase()),
                  text: 'Reset Password',
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildEmailFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Enter your email',
        suffixIcon: Icon(Icons.mail_outline),
        labelText: 'Email',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //  contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
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
