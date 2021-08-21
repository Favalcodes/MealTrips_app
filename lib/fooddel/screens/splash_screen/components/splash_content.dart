import 'package:flutter/material.dart';
import 'package:mealtrips/size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key key,
    this.image,
    this.title,
    this.desc,
  }) : super(key: key);

  final String title, desc, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 60.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Image.asset(
            image,
            height: getProportionateScreenHeight(250),
            width: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 40),
        Text(
          title,
          style: TextStyle(
              fontSize: SizeConfig.screenWidth * 0.07,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textSelectionColor),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          width: SizeConfig.screenWidth / 1.5,
          child: Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: SizeConfig.screenWidth * 0.04,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).hintColor),
          ),
        ),
      ],
    );
  }
}
