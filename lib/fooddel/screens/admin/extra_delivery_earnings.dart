import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/data/model/delivery_earnings.dart';
import 'package:mealtrips/fooddel/data/repository/delivery_earnings_repo.dart';
import 'package:mealtrips/fooddel/screens/widgets/empty_widget.dart';
import 'package:mealtrips/fooddel/screens/widgets/transactions_tile.dart';
import 'package:mealtrips/fooddel/utility/colorResources.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/fooddel/utility/style.dart';
import 'package:mealtrips/size_config.dart';

class ExtraDeliveryEarningsScreen extends StatefulWidget {
  @override
  _DeliveryEarningsScreenState createState() => _DeliveryEarningsScreenState();
}

class _DeliveryEarningsScreenState extends State<ExtraDeliveryEarningsScreen> {
  List<DeliveryEarnings> earnings = [];
  List<DeliveryEarnings> tadayEarningsList = [];
  DeliveryEarningsRepo deliveryEarningsRepo = DeliveryEarningsRepo();
  bool isLoading = true;
  double todayEarnigns = 0.0;
  double totalEarnings = 0.0;

  @override
  void initState() {
    super.initState();
    gettransactions();
  }

  void gettransactions() async {
    earnings = await deliveryEarningsRepo.getExtraEarnings();

    earnings.forEach((element) {
      totalEarnings = totalEarnings + element.amount;
    });

    tadayEarningsList = await deliveryEarningsRepo.todayExtraEarnings();
    tadayEarningsList.forEach((element) {
      if (element.date == date) {
        todayEarnigns = todayEarnigns + element.amount;
      }
    });

    setState(() => totalEarnings = totalEarnings);
    setState(() => todayEarnigns = todayEarnigns);

    setState(() => earnings = earnings);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Hero(
            tag: 7,
            child: Container(
              color: kPrimaryColor2,
              width: MediaQuery.of(context).size.width,
              height: 170.0,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Text("Extra Delivery Earnings",
                      style: poppinsBold.copyWith(
                          fontSize: 20, color: ColorResources.COLOR_WHITE)),
                ),
                Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: ColorResources.COLOR_WHITE,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 20,
                                offset:
                                    Offset(3, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                "Overview",
                                textAlign: TextAlign.left,
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    // height: SizeConfig.screenHeight * 0.2,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        boxShadow: [kDefaultShadow]),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Today\'s earnings',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      SizeConfig.screenWidth *
                                                          0.04,
                                                  color: Theme.of(context)
                                                      .textSelectionColor),
                                            ),
                                            Text(
                                              "N" +
                                                  formatter
                                                      .format(todayEarnigns)
                                                      .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                  color: Theme.of(context)
                                                      .textSelectionColor),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Total earnings',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      SizeConfig.screenWidth *
                                                          0.04,
                                                  color: Theme.of(context)
                                                      .textSelectionColor),
                                            ),
                                            Text(
                                              "N" +
                                                  formatter
                                                      .format(totalEarnings)
                                                      .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                  color: Theme.of(context)
                                                      .textSelectionColor),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              getProportionateScreenHeight(10),
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: ColorResources.COLOR_WHITE,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 20,
                                offset:
                                    Offset(3, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 20.0),
                              Text("Earnings", textAlign: TextAlign.left),
                              earnings.length == 0
                                  ? Column(
                                      children: [
                                        SizedBox(height: 50),
                                        EmptyWidget(
                                          "No recent transactions found.",
                                          Icons.monetization_on,
                                        ),
                                      ],
                                    )
                                  : ListView.builder(
                                      itemCount: earnings.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, i) {
                                        return TransactionsTile(
                                          orderNo: null,
                                          date: earnings[i].date.toString(),
                                          trackingNo: 'IW3475453455',
                                          quantity: '1',
                                          amount: formatter
                                              .format(earnings[i].amount)
                                              .toString(),
                                          status: 'Recieved',
                                          press: () {},
                                        );
                                      }),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
