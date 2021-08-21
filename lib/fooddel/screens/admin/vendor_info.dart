import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/data/model/order_transaction_model.dart';
import 'package:mealtrips/fooddel/data/model/vendor_model.dart';
import 'package:mealtrips/fooddel/data/repository/order_transaction_repo.dart';
import 'package:mealtrips/fooddel/screens/vendor/edt_profile.dart';
import 'package:mealtrips/fooddel/screens/profile_picture/photo_preview.dart';
import 'package:mealtrips/fooddel/screens/widgets/empty_widget.dart';
import 'package:mealtrips/fooddel/screens/widgets/transactions_tile.dart';
import 'package:mealtrips/fooddel/utility/colorResources.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/fooddel/utility/style.dart';
import 'package:mealtrips/size_config.dart';

class VendoInfo extends StatefulWidget {
  final VendorModel vendour;
  VendoInfo(this.vendour);
  @override
  _VendoInfoState createState() => _VendoInfoState();
}

class _VendoInfoState extends State<VendoInfo> {
  List<OrderTransactionModel> transactions = [];
  OrderTransactionRepo transactionRepo = OrderTransactionRepo();
  bool isLoading = true;
  double balance = 0.0;

  @override
  void initState() {
    super.initState();
    gettransactions();
    balance = widget.vendour.balance;
  }

  void gettransactions() async {
    transactions = await transactionRepo.getTransactions(widget.vendour.id);
    setState(() => transactions = transactions);
    setState(() => isLoading = false);
  }

  void payOut() {
    if (widget.vendour.balance < 1.0) {
      SnackBar snackBar = SnackBar(content: Text("Insufficient fund."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      resturantRef.doc(widget.vendour.id).update({'balance': 0.0});
      setState(() => balance = 0.0);
      SnackBar snackBar = SnackBar(content: Text("Vendor Pay out successful."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Timer(Duration(seconds: 3), (){
        Navigator.of(context).pop(context);
      });
    }
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
              color:kPrimaryColor2,
              width: MediaQuery.of(context).size.width,
              height: 170.0,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Transaction Overview",
                          style: poppinsBold.copyWith(
                              fontSize: 20, color: ColorResources.COLOR_WHITE)),
                      CircleAvatar(
                        radius: 18.0,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(Icons.person, color: kPrimaryColor),
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VendorProfile(widget.vendour, 'Admin'))),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
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
                                "Wallet Balance",
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
                                              'Balance',
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
                                                      .format(widget
                                                          .vendour.balance)
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
                                  )),
                              Material(
                                elevation: 2.0,
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: GestureDetector(
                                    onTap: () => controllPoyout(context),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 8.0),
                                      child: Text(
                                        "Pay Out  N" +
                                            formatter
                                                .format(balance)
                                                .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 14.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
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
                              Text("Transactions", textAlign: TextAlign.left),
                              transactions.length == 0
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
                                      itemCount: transactions.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, i) {
                                        return TransactionsTile(
                                          orderNo:transactions[i].orderNumber,
                                          date: transactions[i].date.toString(),
                                          trackingNo: 'IW3475453455',
                                          quantity: '1',
                                          amount: formatter
                                              .format(transactions[i].amount)
                                              .toString(),
                                          status: 'Recieved',
                                          press: () {
                                            //  Navigator.push(context, MaterialPageRoute(builder: (context) =>OrderDetails()));
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

  CircleAvatar avatar() {
    return CircleAvatar(
        radius: 30.0,
        backgroundColor: Colors.grey[200],
        child: Icon(
          Icons.person,
          size: 40.0,
          color: Colors.grey[400],
        ));
  }

  void photoPreview(BuildContext context, String photo) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhotoPreview(photo)));
  }

  dynamic controllPoyout(mContext) {
    showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Are sure you want to continue?",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w500)),
            children: <Widget>[
              SimpleDialogOption(
                child:
                    Text("Pay vendor", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.pop(context);
                  payOut();
                },
              ),
              SimpleDialogOption(
                child: Text("Cancel", style: TextStyle(color: Colors.black)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
}
