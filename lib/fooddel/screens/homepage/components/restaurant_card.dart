import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/data/model/vendor_model.dart';
import 'package:mealtrips/size_config.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    Key key,
    this.press,
    @required this.restaurant,
  }) : super(key: key);

  final GestureTapCallback press;
  final VendorModel restaurant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: press,
        child: Container(
          // height: getProportionateScreenHeight(160),
          width: getProportionateScreenWidth(216),
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.0),
              color: Theme.of(context).cardColor,
              boxShadow: [kDefaultShadow]
            ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: getProportionateScreenHeight(100),
                  width: getProportionateScreenWidth(216),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(7.0),
                          topLeft: Radius.circular(7.0)),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(restaurant.image),
                          fit: BoxFit.cover)),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.black26,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: getProportionateScreenHeight(29),
                            width: 41,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(7.0))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Color(0XFFFFC107),
                                ),
                                Text(
                                  restaurant.rating.toStringAsFixed(1),
                                  style: TextStyle(
                                      fontSize: getProportionateScreenWidth(12),
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(5),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            //  width: getProportionateScreenWidth(100),
                            child: Container(
                             width: MediaQuery.of(context).size.width - 240,
                              child: Text(
                               restaurant.name, overflow: TextOverflow.ellipsis, maxLines: 2,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: SizeConfig.screenWidth * 0.04,
                                    color: Theme.of(context).textSelectionColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 108,
                            child: Text(
                              restaurant.address,
                              style: TextStyle(
                                  fontSize: SizeConfig.screenWidth * 0.03,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).hintColor),
                            ),
                          )
                        ],
                      ),
                      //Spacer(),
                      // Text(
                      //   "N500",
                      //   style: TextStyle(
                      //       fontSize: getProportionateScreenWidth(17),
                      //       fontWeight: FontWeight.bold,
                      //     color: Theme.of(context).textSelectionColor
                      //   ),
                      // )
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
}
