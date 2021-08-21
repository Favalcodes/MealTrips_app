import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/data/model/order_transaction_model.dart';
import 'package:mealtrips/fooddel/data/repository/order_transaction_repo.dart';
import 'package:mealtrips/fooddel/screens/profile_picture/photo_preview.dart';
import 'package:mealtrips/fooddel/screens/vendor/vendor_tab.dart';
import 'package:mealtrips/fooddel/screens/widgets/empty_widget.dart';
import 'package:mealtrips/fooddel/screens/widgets/transactions_tile.dart';
import 'package:mealtrips/fooddel/utility/colorResources.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/fooddel/utility/style.dart';
import 'package:mealtrips/size_config.dart';

class VendorTransactions extends StatefulWidget {
  final String userId;
  VendorTransactions(this.userId);
  @override
  _VendorTransactionsState createState() => _VendorTransactionsState();
}

class _VendorTransactionsState extends State<VendorTransactions> {
  List<OrderTransactionModel> transactions = [];
  OrderTransactionRepo transactionRepo = OrderTransactionRepo();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    gettransactions();
  }

  void gettransactions() async {
    transactions = await transactionRepo.getTransactions(vendor.id);
    setState(() => transactions = transactions);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: 7,
            child: Container(
              color: Theme.of(context).accentColor,
              width: MediaQuery.of(context).size.width,
              height: 170.0,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Text("Transaction Overview",
                      style: poppinsBold.copyWith(
                          fontSize: 20, color: ColorResources.COLOR_WHITE)),
                ),
                Expanded(
                  child: vendor == null
                      ? Center(
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.red),
                              strokeWidth: 4.0,
                            ),
                          ),
                        )
                      : ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                                margin: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color:Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 20,
                                      offset: Offset(
                                          3, 3), // changes position of shadow
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Balance',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: SizeConfig
                                                                .screenWidth *
                                                            0.04,
                                                        color: Theme.of(context)
                                                            .textSelectionColor),
                                                  ),
                                                  Text(
                                                    "N" +
                                                        formatter
                                                            .format(
                                                                vendor.balance)
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15,
                                                        color: Theme.of(context)
                                                            .textSelectionColor),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10),
                                              ),
                                            ],
                                          ),
                                        ))
                                  ],
                                )),
                            Container(
                                margin: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color:Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 20,
                                      offset: Offset(
                                          3, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 20.0),
                                    Text("Transactions",
                                        textAlign: TextAlign.left),
                                    transactions.length == 0
                                        ? Column(
                                            children: [
                                              SizedBox(height: 50),
                                              EmptyWidget(
                                                  "Your recent transactions will appear here.",
                                                  Icons.monetization_on,
                                                
                                              ),
                                            ],
                                          )
                                        : ListView.builder(
                                            itemCount: transactions.length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, i) {
                                              return TransactionsTile(
                                                orderNo: transactions[i].orderNumber,
                                                date: transactions[i]
                                                    .date
                                                    .toString(),
                                                trackingNo: 'IW3475453455',
                                                quantity: '1',
                                                amount: formatter
                                                    .format(
                                                        transactions[i].amount)
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
}
