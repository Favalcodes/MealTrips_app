import 'package:flutter/material.dart';
import 'package:mealtrips/fooddel/components/default_buttons.dart';
import 'package:mealtrips/fooddel/screens/signup_screen/signup_screen.dart';
import 'package:mealtrips/fooddel/screens/splash_screen/components/splash_content.dart';
import 'package:mealtrips/size_config.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    List<Map<String, String>> splashData = [
      {
        "title": "Quick Delivery",
        "desc": "Order food from anywhere and get it withing few minutes",
        "image": "assets/images/rider2.png"
      },
    ];
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(height: getProportionateScreenWidth(30)),
          SplashContent(
            title: splashData[0]['title'],
            desc: splashData[0]['desc'],
            image: splashData[0]['image'],
          ),
          SizedBox(height: getProportionateScreenHeight(80)),
          DefaultButton(
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignupScreen()));
            },
            text: 'Continue',
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
        ],
      )),
    );
  }
}
