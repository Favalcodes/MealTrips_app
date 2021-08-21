import 'package:flutter/material.dart';
import 'package:mealtrips/fooddel/components/default_buttons.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/reset_password/reset_password_screen.dart';
import 'package:mealtrips/fooddel/screens/signup_screen/signup_screen.dart';
import 'package:mealtrips/fooddel/services/Authentication.dart';
import 'package:mealtrips/size_config.dart';
import 'package:mealtrips/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  AuthImplementation auth = Auth();
  bool showLoader = false;
  int visibleCount = 0;
  Icon visibilityIcon = Icon(Icons.visibility);
  bool obscurePassword = true;

  Future<void> handleUserSignIn(String email, String password) async {
    setState(() => showLoader = true);
    if (password == "" || email == "") {
      SnackBar snackBar =
          SnackBar(content: Text("Please fill out all fields."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      try {
        await auth.SignIn(email, password);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeTabs()));
      } catch (e) {
        SnackBar snackBar = SnackBar(content: Text(e.message.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    setState(() => showLoader = false);
  }

  void visibilityChange() {
    visibleCount++;
    if (visibleCount == 1) {
      setState(() {
        obscurePassword = false;
        visibilityIcon = Icon(Icons.visibility_off);
      });
    } else {
      setState(() {
        obscurePassword = true;
        visibilityIcon = Icon(Icons.visibility);
        visibleCount = 0;
      });
    }
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
                      Text(
                        'Meal Trips',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.screenWidth * 0.07,
                            color: Theme.of(context).textSelectionColor),
                      ),
                      SizedBox(height: getProportionateScreenHeight(100)),
                      buildEmailFormField(context),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      buildPasswordFormField(context),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetPassword())),
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeConfig.screenWidth * 0.04,
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).hintColor),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(40)),
                showLoader
                    ? SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.redAccent),
                          strokeWidth: 2.0,
                        ),
                      )
                    : DefaultButton(
                        press: () => handleUserSignIn(
                            emailController.text, passwordController.text),
                        text: 'Signin',
                      ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                            fontSize: SizeConfig.screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).textSelectionColor),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "SignUp",
                        style: TextStyle(
                            fontSize: SizeConfig.screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor),
                      ),
                    ],
                  ),
                )
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

  TextFormField buildPasswordFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: passwordController,
      obscureText: obscurePassword,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Enter your password',
        labelText: 'Password',
        suffixIcon: IconButton(
            icon: visibilityIcon, onPressed: () => visibilityChange()),
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
