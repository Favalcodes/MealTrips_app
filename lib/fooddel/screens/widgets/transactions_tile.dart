import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/size_config.dart';

class TransactionsTile extends StatelessWidget {
  const TransactionsTile({
    Key key,
    this.orderNo,
    this.date,
    this.trackingNo,
    this.quantity,
    this.amount,
    this.status,
    this.press,
  }) : super(key: key);

  final String orderNo, date, trackingNo, quantity, amount, status;
  final GestureTapCallback press;

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
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [kDefaultShadow]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    orderNo == null
                        ? SizedBox.shrink()
                        : Text(
                            "Order ID: " + orderNo,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.screenWidth * 0.04,
                                color: Theme.of(context).textSelectionColor),
                          ),
                    Text(
                      date,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: SizeConfig.screenWidth * 0.04,
                          color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Row(
                  children: [
                    Text(
                      'Total amount',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: SizeConfig.screenWidth * 0.04,
                          color: Theme.of(context).hintColor),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'N' + amount,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Theme.of(context).textSelectionColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      status,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: SizeConfig.screenWidth * 0.04,
                          color: Color(0XFF55D85A)),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
