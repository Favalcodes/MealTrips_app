import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/components/default_buttons.dart';
import 'package:mealtrips/fooddel/screens/cart/cart_screen.dart';
import 'package:mealtrips/size_config.dart';

addMediaModal(context) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: SizeConfig.screenHeight / 2,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [kDefaultShadow],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/svgs/addedtocart.svg',
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: getProportionateScreenHeight(6),
              ),
              Text(
                'Added to cart',
                style: TextStyle(
                    color: kPrimaryColor2,
                    fontSize: SizeConfig.screenWidth * 0.05,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              DefaultButton(
                press: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartScreen()));
                },
                text: 'View cart and Check out',
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: getProportionateScreenHeight(60),
                  width: 75 / 100 * SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: kPrimaryColor2,
                      ),
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                    child: Text(
                      'Continue shopping',
                      style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          color: kPrimaryColor2),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      });
}
