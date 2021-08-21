import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/data/model/order_model.dart';
import 'package:mealtrips/fooddel/data/repository/order_repo.dart';
import 'package:mealtrips/fooddel/screens/admin/order_details.dart';
import 'package:mealtrips/fooddel/screens/order_details/order_details.dart';
import 'package:mealtrips/fooddel/screens/widgets/empty_widget.dart';
import 'package:mealtrips/fooddel/screens/widgets/transactions_tile.dart';
import 'package:mealtrips/fooddel/utility/colorResources.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/fooddel/utility/style.dart';
import 'package:mealtrips/size_config.dart';

class OrderOverview extends StatefulWidget {
  @override
  _OrderOverviewState createState() => _OrderOverviewState();
}

class _OrderOverviewState extends State<OrderOverview> {
  List<OrderModel> orderList = [];
  List<OrderModel> todayOrder = [];
  OrderRepo orderRepo = OrderRepo();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    gettransactions();
  }

  void gettransactions() async {
    orderList = await orderRepo.getOrder();

    todayOrder = await orderRepo.todayOrder();

    setState(() => todayOrder = todayOrder);
    setState(() => orderList = orderList);

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
                  child: Text("Order Overview",
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
                                              'Today',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      SizeConfig.screenWidth *
                                                          0.04,
                                                  color: Theme.of(context)
                                                      .textSelectionColor),
                                            ),
                                            Text(
                                              todayOrder.length.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                  color: Theme.of(context)
                                                      .textSelectionColor),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Total',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      SizeConfig.screenWidth *
                                                          0.04,
                                                  color: Theme.of(context)
                                                      .textSelectionColor),
                                            ),
                                            Text(
                                              orderList.length.toString(),
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
                              Text("Recent Order", textAlign: TextAlign.left),
                              orderList.length == 0
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
                                      itemCount: orderList.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, i) {
                                        return TransactionsTile(
                                          orderNo: orderList[i].orderNumber,
                                          date: orderList[i].date.toString(),
                                          trackingNo: 'IW3475453455',
                                          quantity: '1',
                                          amount: formatter
                                              .format(orderList[i].amount)
                                              .toString(),
                                          status: 'Recieved',
                                          press: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AdminOrderDetails(
                                                            orderList[i])));
                                          },
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
