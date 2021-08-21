import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/screens/splash_screen/splash_screen.dart';
import 'package:mealtrips/size_config.dart';

class UnboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 8),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => SplashScreen())));
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/page.jpg"),
                  fit: BoxFit.cover)),
          child: Container(
              color: Colors.black45,
              child: Center(
                child: Text(
                  "Meal Trips",
                  style: TextStyle(
                      fontSize: 35.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )),
        ));
  }
}
