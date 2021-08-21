import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/components/customNavBar.dart';
import 'package:mealtrips/fooddel/data/model/cart_model.dart';
import 'package:mealtrips/fooddel/data/model/order_model.dart';
import 'package:mealtrips/fooddel/data/model/user_model.dart';
import 'package:mealtrips/fooddel/data/model/vendor_model.dart';
import 'package:mealtrips/fooddel/data/repository/item_repo.dart';
import 'package:mealtrips/fooddel/data/repository/order_Items_repo.dart';
import 'package:mealtrips/fooddel/data/repository/user_repo.dart';
import 'package:mealtrips/fooddel/screens/vendor/order_details.dart';
import 'package:mealtrips/fooddel/screens/widgets/progress_widget.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/size_config.dart';

class OrderDetails extends StatefulWidget {
  final OrderModel orderItems;
  OrderDetails(this.orderItems);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  OrderItemsRepo orderItemsRepo = OrderItemsRepo();
  UserRepo userRepo = UserRepo();
  ItemRepo itemRepo = ItemRepo();
  bool isLoading = true;
  List<CartModel> orderItems = [];
  VendorModel vendor;
  bool isCancelled = false;
  bool canCancel = false;

  @override
  void initState() {
    super.initState();
    getOrderItems(widget.orderItems.orderId);
    getVendourDetails();
    canCancelOrder();
    isCancelled = widget.orderItems.cancelled;
  }

  void canCancelOrder() {
    int sec = DateTime.now().millisecondsSinceEpoch - widget.orderItems.seconds;
    if (sec < 60000) {
      setState(() => canCancel = true);
    } else {
      setState(() => canCancel = false);
    }
  }

  void cancelOrder() {
    setState(() => isCancelled = true);
    orderRef.doc(widget.orderItems.id).update({
      'cancelled': true,
    });
    updateTransactionHistory();
    vendorNotification();
    SnackBar snackBar = SnackBar(content: Text("Order Cancelled"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateTransactionHistory() async {
    //Delete from vendor transactions
    vendorTransactionRef
        .doc(widget.orderItems.resId)
        .collection("Items")
        .doc(widget.orderItems.orderId)
        .delete();

    //Deduct from vendor balance
    await resturantRef.doc(widget.orderItems.resId).get().then((value) {
      VendorModel vendorModel = VendorModel.fromDocument(value);
      double balance = vendorModel.balance;
      double newBalance = balance - widget.orderItems.amount;
      resturantRef.doc(widget.orderItems.resId).update({
        "balance": newBalance,
      });
    });
  }

  void getOrderItems(String orderId) async {
    orderItems = await orderItemsRepo.getOrderItems(orderId);
    setState(() => orderItems = orderItems);
  }

  void getVendourDetails() async {
    vendor = await userRepo.getVendor(widget.orderItems.resId);
    setState(() => vendor = vendor);
    setState(() => isLoading = false);
  }

  void vendorNotification() {
    usersReference.doc(widget.orderItems.resId).get().then((value) {
      String token = UserModel.fromDocument(value).token;
      vendorNotRef.doc(widget.orderItems.resId).collection("Items").doc().set({
        'timestamp': timestamp,
        'type': 'cancelled',
        'orderId': widget.orderItems.orderNumber,
        'seen': 0,
        'date': date,
        'token': token
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Order details',
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
      body: isLoading
          ? circularProgress()
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order No: N${widget.orderItems.orderNumber}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.screenWidth * 0.04,
                                  ),
                                ),
                                Text(
                                  widget.orderItems.date,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: SizeConfig.screenWidth * 0.04,
                                      color: Theme.of(context).hintColor),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(15),
                            ),
                            Text(
                              '${widget.orderItems.quantity} Items',
                              style: TextStyle(
                                  fontSize: SizeConfig.screenWidth * 0.04,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      ...List.generate(orderItems.length, (index) {
                        return VendourOrderDetailsCard(
                            product: orderItems[index], press: () {});
                      }),
                      SizedBox(height: getProportionateScreenHeight(15)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Restuarant information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.screenWidth * 0.05,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            SizedBox(
                              height: getProportionateScreenHeight(15),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: SizeConfig.screenWidth / 3,
                                  child: Text(
                                    'Restuarant name:',
                                    style: TextStyle(
                                        fontSize: SizeConfig.screenWidth * 0.04,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.screenWidth * 0.5,
                                  child: Text(
                                    vendor.name,
                                    style: TextStyle(
                                        fontSize: SizeConfig.screenWidth * 0.04,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(15),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: SizeConfig.screenWidth / 3,
                                  child: Text(
                                    'Address:',
                                    style: TextStyle(
                                        fontSize: SizeConfig.screenWidth * 0.04,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.screenWidth * 0.5,
                                  child: Text(
                                    vendor.address,
                                    style: TextStyle(
                                        fontSize: SizeConfig.screenWidth * 0.04,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(15),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: SizeConfig.screenWidth / 3,
                                  child: Text(
                                    'Phone Number:',
                                    style: TextStyle(
                                        fontSize: SizeConfig.screenWidth * 0.04,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.screenWidth / 2,
                                  child: Text(
                                    vendor.phone,
                                    style: TextStyle(
                                        fontSize: SizeConfig.screenWidth * 0.04,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            SizedBox(
                              height: getProportionateScreenHeight(15),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: SizeConfig.screenWidth / 3,
                                  child: Text(
                                    'Total Amount:',
                                    style: TextStyle(
                                        fontSize: SizeConfig.screenWidth * 0.04,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.screenWidth / 2,
                                  child: Text(
                                    'N' +
                                        formatter
                                            .format(widget.orderItems.amount)
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: SizeConfig.screenWidth * 0.04,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(20),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Order information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.screenWidth * 0.05,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            SizedBox(
                              height: getProportionateScreenHeight(15),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: SizeConfig.screenWidth / 3,
                                  child: Text(
                                    'Estimated package time:',
                                    style: TextStyle(
                                        fontSize: SizeConfig.screenWidth * 0.04,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.screenWidth / 2,
                                  child: Text(
                                    '${widget.orderItems.pTime} mins',
                                    style: TextStyle(
                                        fontSize: SizeConfig.screenWidth * 0.04,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      widget.orderItems.dTime == ""
                          ? SizedBox.shrink()
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: getProportionateScreenHeight(15),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: SizeConfig.screenWidth / 3,
                                        child: Text(
                                          'Estimated delivery time:',
                                          style: TextStyle(
                                              fontSize:
                                                  SizeConfig.screenWidth * 0.04,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(
                                        width: SizeConfig.screenWidth / 2,
                                        child: Text(
                                          '${widget.orderItems.dTime} mins',
                                          style: TextStyle(
                                              fontSize:
                                                  SizeConfig.screenWidth * 0.04,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                      CheckboxListTile(
                        value: widget.orderItems.packed,
                        activeColor: kPrimaryColor,
                        title: Text('Order Packed',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.screenWidth * 0.043)),
                        onChanged: (value) {},
                      ),
                      CheckboxListTile(
                          value: widget.orderItems.onTransit,
                          activeColor: kPrimaryColor,
                          onChanged: (value) {},
                          title: Text(
                            'On Transit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.screenWidth * 0.043),
                          )),
                      CheckboxListTile(
                          value: widget.orderItems.delivered,
                          activeColor: kPrimaryColor,
                          onChanged: (value) {},
                          title: Text(
                            'Delivered',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.screenWidth * 0.043),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      isCancelled
                          ? SizedBox.shrink()
                          : widget.orderItems.delivered
                              ? SizedBox.shrink()
                              : !canCancel
                                  ? SizedBox.shrink()
                                  : Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          cancelDialog(context);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height:
                                              getProportionateScreenHeight(60),
                                          width:
                                              75 / 100 * SizeConfig.screenWidth,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: kPrimaryColor,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          child: Center(
                                            child: Text(
                                              'Cancel Order',
                                              style: TextStyle(
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          18),
                                                  color: kPrimaryColor),
                                            ),
                                          ),
                                        ),
                              ),
                         )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  dynamic cancelDialog(
    mContext,
  ) {
    return showDialog(
        context: mContext,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Column(
              children: <Widget>[
                Text("Are you sure you want to cancel this order?",
                    style: TextStyle(fontWeight: FontWeight.w100)),
                SizedBox(
                  width: 10.0,
                ),
                Divider(),
                SizedBox(
                  width: 100.0,
                ),
              ],
            ),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlineButton(
                      borderSide: BorderSide(color: Colors.deepOrange),
                      child: Text("Yes"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      onPressed: () {
                        Navigator.pop(context);
                        cancelOrder();
                      }),
                  SizedBox(
                    width: 10.0,
                  ),
                  OutlineButton(
                      borderSide: BorderSide(color: Colors.lightGreen),
                      child: Text("No"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      onPressed: () async {
                        Navigator.pop(context);
                      })
                ],
              ),
              SizedBox(
                width: 100.0,
              ),
            ],
          );
        });
  }
}
