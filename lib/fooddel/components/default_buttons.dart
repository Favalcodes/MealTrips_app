import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);

  final String text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        height: getProportionateScreenHeight(60),
        width: SizeConfig.screenWidth * 0.75,
        decoration: BoxDecoration(
            color: kPrimaryColor, borderRadius: BorderRadius.circular(30.0)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: SizeConfig.screenWidth * 0.045, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ReversedDefaultButton extends StatelessWidget {
  const ReversedDefaultButton({
    Key key,
    @required this.text,
    @required this.press,
  }) : super(key: key);

  final String text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        GestureDetector(
          onTap: press,
          child: Container(
            height: getProportionateScreenHeight(60),
            width: 75 / 100 * SizeConfig.screenWidth,
            decoration: BoxDecoration(
                color:kPrimaryColor2,
                borderRadius: BorderRadius.circular(40.0)),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
