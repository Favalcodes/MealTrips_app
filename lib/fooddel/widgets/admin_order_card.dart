
import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/size_config.dart';

class AdminOrderCard extends StatelessWidget {
  const AdminOrderCard({
    Key key,
    this.orderNo,
    this.date,
    this.trackingNo,
    this.quantity,
    this.amount,
    this.status,
    this.isDelivered,
    this.press,
  }) : super(key: key);

  final String orderNo, date, trackingNo, quantity, amount, status;
  final GestureTapCallback press;
  final bool isDelivered;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: GestureDetector(
          onTap: press,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            // height: SizeConfig.screenHeight * 0.2,
            width: double.infinity,
            decoration: BoxDecoration(
                color: kBgColor,
                boxShadow: [kDefaultShadow]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      orderNo,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.screenWidth * 0.04,
                          color:kBlack),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: SizeConfig.screenWidth * 0.04,
                          color:kHintColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Items',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: SizeConfig.screenWidth * 0.04,
                              color:kHintColor),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          quantity,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.screenWidth * 0.04,
                              color: kBlack),
                        ),
                      ],
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total amount',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: SizeConfig.screenWidth * 0.04,
                              color: kHintColor),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'N' + amount,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: kBlack),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: SizeConfig.screenHeight * 0.04,
                      width: getProportionateScreenWidth(100),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: kBlack,
                              width: 1)),
                      child: Center(
                        child: Text(
                          'Details',
                          style: TextStyle(
                              fontSize: SizeConfig.screenWidth * 0.04,
                              fontWeight: FontWeight.w500,
                              color: kBlack),
                        ),
                      ),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: SizeConfig.screenWidth * 0.04,
                          color: isDelivered ? Color(0XFF55D85A) : kPrimaryColor) ,
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}