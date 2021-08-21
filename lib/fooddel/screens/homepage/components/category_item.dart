import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/size_config.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem(
      {Key key, @required this.title, @required this.icon, this.index})
      : super(key: key);

  final String title,  icon;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [kDefaultShadow],
          color:index == 0 ? kPrimaryColor2 : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: getProportionateScreenHeight(60),
                width: getProportionateScreenHeight(60),
                decoration: BoxDecoration(
                  color:index == 0 ? Colors.white : kPrimaryColor2,
                    shape: BoxShape.circle,
                    //border:Border.all(color:kPrimaryColor)
                   ),
                child: SvgPicture.asset(
                  icon,
                  height: getProportionateScreenHeight(20),
                  width: getProportionateScreenHeight(20),
                  color: index == 0 ? kPrimaryColor2 : Colors.white,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 0.03,
                    fontWeight: FontWeight.bold,
                    color:index == 0 ?  Colors.white : Theme.of(context).textSelectionColor),
              ),
               SizedBox(
                height: 5,
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color:index == 0 ?  Colors.white : kPrimaryColor2,
                  shape: BoxShape.circle
                ),
                child: Center(child: Text(">", style:TextStyle(color:index == 0 ?  Colors.black : Colors.white),)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
