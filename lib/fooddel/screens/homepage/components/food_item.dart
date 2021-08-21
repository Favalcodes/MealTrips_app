import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/data/model/item_model.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/size_config.dart';

class FoodItem extends StatelessWidget {
  const FoodItem({
    Key key,
    this.discounted = false,
    this.press,
    this.items,
  }) : super(key: key);

  final bool discounted;
  final GestureTapCallback press;
  final ItemModel items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: getProportionateScreenWidth(160),
        decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(15),
           boxShadow: [kDefaultShadow],
            color: Theme.of(context).cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left:6.0, right: 6, top: 6,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: press,
                child: Container(
                  height: getProportionateScreenHeight(146),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(items.image),
                          fit: BoxFit.cover)),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black26,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (discounted == true)
                            Container(
                              height: getProportionateScreenHeight(23),
                              width: getProportionateScreenWidth(38),
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7))),
                              child: Center(
                                  child: Text(
                                items.discount.toString(),
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(2),
                                  height: getProportionateScreenHeight(23),
                                  width: getProportionateScreenWidth(50),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(7),
                                      )),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: getProportionateScreenWidth(16),
                                        color: Color(0XFFFFC107),
                                      ),
                                      Text(
                                        items.rating.toStringAsFixed(1),
                                        style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(12),
                                            fontWeight: FontWeight.w600,
                                            color: kTextColorLight),
                                      )
                                    ],
                                  )),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: getProportionateScreenWidth(7),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 80.0,
                    child: Text(
                      items.itemName,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: SizeConfig.screenWidth * 0.04,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).textSelectionColor),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 50.0,
                    child: Text(
                      'N' + formatter.format(items.itemPrice).toString(), overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: SizeConfig.screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor2),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
