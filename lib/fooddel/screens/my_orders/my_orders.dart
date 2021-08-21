import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/components/customNavBar.dart';
import 'package:mealtrips/fooddel/data/model/order_model.dart';
import 'package:mealtrips/fooddel/data/repository/order_repo.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/order_details/order_details.dart';
import 'package:mealtrips/fooddel/screens/widgets/empty_widget.dart';
import 'package:mealtrips/fooddel/screens/widgets/progress_widget.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/size_config.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<String> categories = ["Delivered", "Processing", "Cancelled"];
  List<OrderModel> orderList = [];
  List<OrderModel> myOrderList = [];
  List<OrderModel> filteredList = [];
  OrderRepo orderRepo = OrderRepo();
  bool isLoading = true;
  int i = 0;

  List<OrderModel> delivered = [];
  List<OrderModel> cancelled = [];
  List<OrderModel> processing = [];

  @override
  void initState() {
    super.initState();
    getcartList();
  }

  void getcartList() async {
    orderList = await orderRepo.getOrder();
    orderList.forEach((element) {
      if (element.userId == onlineUser.id) {
        myOrderList.add(element);
      }
    });

    myOrderList.forEach((element) {
      if (element.delivered == true) {
        delivered.add(element);
      } else if (element.cancelled == true) {
        cancelled.add(element);
      } else {
        processing.add(element);
      }
    });
    setState(() => processing = processing);
    setState(() => delivered = delivered);
    setState(() => cancelled = cancelled);
    setState(() => filteredList = delivered);
    setState(() => isLoading = false);
  }

  void handleCategory(int index) {
    if (index == 0) {
      setState(() {
        i = index;
        filteredList = delivered;
      });
    } else if (index == 1) {
      setState(() {
        i = index;
        filteredList = processing;
      });
    } else {
      setState(() {
        i = index;
        filteredList = cancelled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My orders',
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.screenWidth * 0.04,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).textSelectionColor),
      ),
      bottomNavigationBar: CustomNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...List.generate(categories.length, (index) {
                      return GestureDetector(
                        onTap: () => handleCategory(index),
                        child: MyOrdersCategoryItem(
                          isSelected: i == index ? true : false,
                          category: categories[index],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 20),
              isLoading
                  ? circularProgress()
                  : filteredList.length == 0
                      ? Column(
                          children: [
                            SizedBox(height: 50),
                            EmptyWidget(i == 0
                                ? "No delivered other."
                                : i == 1
                                    ? "No processing order."
                                    : "No cancelled order.",
                                    Icons.food_bank,
                                   
                                    ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: filteredList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MyOrderCard(
                              isDelivered:filteredList[index].delivered,
                              orderNo:'OrderID N${filteredList[index].orderNumber}',
                              date: filteredList[index].date.toString(),
                              trackingNo: 'IW3475453455',
                              quantity: filteredList[index].quantity.toString(),
                              amount: formatter
                                  .format(filteredList[index].amount)
                                  .toString(),
                              status: i == 0
                                  ? 'Delivered'
                                  : i == 1
                                      ? "Processing"
                                      : "Cancelled",
                              press: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OrderDetails(filteredList[index])));
                              },
                            );
                          })
            ],
          ),
        ),
      ),
    );
  }
}


class MyOrderCard extends StatelessWidget {
  const MyOrderCard({
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
                color: Theme.of(context).colorScheme.surface,
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
                              color: Theme.of(context).hintColor),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          quantity,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.screenWidth * 0.04,
                              color: Theme.of(context).textSelectionColor),
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
                              color: Theme.of(context).textSelectionColor,
                              width: 1)),
                      child: Center(
                        child: Text(
                          'Details',
                          style: TextStyle(
                              fontSize: SizeConfig.screenWidth * 0.04,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).textSelectionColor),
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

class MyOrdersCategoryItem extends StatelessWidget {
  const MyOrdersCategoryItem({
    Key key,
    this.category,
    this.isSelected = false,
  }) : super(key: key);

  final String category;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 6, left: 5, top: 15),
      child: Container(
        height: getProportionateScreenHeight(35),
        width: SizeConfig.screenWidth / 3.3,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).textSelectionColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
                fontSize: SizeConfig.screenWidth * 0.04,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).hintColor),
          ),
        ),
      ),
    );
  }
}
