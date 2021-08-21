import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/data/model/cart_model.dart';
import 'package:mealtrips/fooddel/data/repository/cart_repo.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/size_config.dart';


class OrderConfirmed extends StatefulWidget {
  @override
  _OrderConfirmedState createState() => _OrderConfirmedState();
}

class _OrderConfirmedState extends State<OrderConfirmed> {
  CartRepo cartRepo = CartRepo();
  List<CartModel> cartList = [];

  @override
  void initState() {
    super.initState();
    emptyCart();
  }

  Future<void> emptyCart() async {
    cartList = await cartRepo.getCart(onlineUser.id);
    cartList.forEach((element) async {
      await cartRef.doc(element.id).delete();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 4.5 / 6 * SizeConfig.screenHeight,
              width: double.infinity,
              color: kPrimaryColor2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/svgs/confirmed.svg'),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth / 1.5,
                    child: Text(
                      'Your order has been received',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          height: 1.1,
                          fontSize: SizeConfig.screenWidth * 0.07,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(6),
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth / 1.2,
                    child: Text(
                      'A delivery person will contact you shortly.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: SizeConfig.screenWidth * 0.04,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeTabs()));
              },
              child: Container(
                height: getProportionateScreenHeight(60),
                width: 75 / 100 * SizeConfig.screenWidth,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: kPrimaryColor,
                    ),
                    borderRadius: BorderRadius.circular(40)),
                child: Center(
                  child: Text(
                    'Continue shopping',
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(18),
                        color: kPrimaryColor),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeTabs()));
              },
              child: Container(
                height: 60,
                width: 75 / 100 * SizeConfig.screenWidth,
                decoration: BoxDecoration(
                    color: kPrimaryColor2,
                    borderRadius: BorderRadius.circular(40)),
                child: Center(
                  child: Text(
                    'Back to home',
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(19),
                        color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
