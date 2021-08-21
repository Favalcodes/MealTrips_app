import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/data/model/cart_model.dart';
import 'package:mealtrips/fooddel/data/model/order_model.dart';
import 'package:mealtrips/fooddel/data/model/user_model.dart';
import 'package:mealtrips/fooddel/data/model/vendor_model.dart';
import 'package:mealtrips/fooddel/data/repository/item_repo.dart';
import 'package:mealtrips/fooddel/data/repository/order_Items_repo.dart';
import 'package:mealtrips/fooddel/data/repository/user_repo.dart';
import 'package:mealtrips/fooddel/screens/vendor/select_delivery_merchant.dart';
import 'package:mealtrips/fooddel/screens/delivery/add_delivery_time.dart';
import 'package:mealtrips/fooddel/screens/widgets/progress_widget.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/size_config.dart';

class VendourOrderDetails extends StatefulWidget {
  final OrderModel orderItems;
  final String screen;
  VendourOrderDetails({this.orderItems, this.screen});
  @override
  _VendourOrderDetailsState createState() => _VendourOrderDetailsState();
}

class _VendourOrderDetailsState extends State<VendourOrderDetails> {
  OrderItemsRepo orderItemsRepo = OrderItemsRepo();
  UserRepo userRepo = UserRepo();
  ItemRepo itemRepo = ItemRepo();
  List<VendorModel> deliveryMerchants = [];
  bool isLoading = true;
  List<CartModel> orderItems = [];
  UserModel customer;
  bool itemPacked = false;
  bool isOnTransit = false;
  List<String> selectedMerchant;
  VendorModel vendor;
  bool isDelivered = false;
  String estimatedDeliveryTime;

  @override
  void initState() {
    super.initState();
    getOrderItems(widget.orderItems.orderId);
    fetchUserInfo(widget.orderItems.userId);
    getDeliveryMerchant();
    getVendourDetails();
    itemPacked = widget.orderItems.packed;
    isOnTransit = widget.orderItems.onTransit;
    isDelivered = widget.orderItems.delivered;
    estimatedDeliveryTime = widget.orderItems.dTime;
  }

  void getVendourDetails() async {
    vendor = await userRepo.getVendor(widget.orderItems.resId);
    setState(() => vendor = vendor);
    setState(() => isLoading = false);
  }

  void getOrderItems(String orderId) async {
    orderItems = await orderItemsRepo.getOrderItems(orderId);
    setState(() => orderItems = orderItems);
  }

  void fetchUserInfo(String userId) async {
    customer = await userRepo.customerDetails(userId);
    setState(() => customer = customer);
  }

  void getDeliveryMerchant() async {
    deliveryMerchants = await userRepo.getAllDeliveryMerchant();
    setState(() => deliveryMerchants = deliveryMerchants);
  }

  void orderPacked() {
    if (selectedMerchant == null) {
      SnackBar snackBar =
          SnackBar(content: Text("Please select delivery merchant"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() => itemPacked = true);
      orderRef.doc(widget.orderItems.id).update({
        'packed': true,
        'deliveryMerchant': selectedMerchant[0],
      });

      //Send notifications
      deliveryRequestNotification();

      SnackBar snackBar = SnackBar(
          content:
              Text("Delivery notification sent to ${selectedMerchant[1]} "));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void onTransit() {
    setState(() => isOnTransit = true);
    orderRef.doc(widget.orderItems.id).update({
      'onTransit': true,
      'dTime': estimatedDeliveryTime,
    });

    // notify customer
    usersReference.doc(widget.orderItems.userId).get().then((value) {
      String token = UserModel.fromDocument(value).token;
      notificationRef
          .doc(widget.orderItems.userId)
          .collection("Items")
          .doc()
          .set({
        'timestamp': timestamp,
        'body': 'Your order is on transit to arrive at $estimatedDeliveryTime mins.',
        'orderId': widget.orderItems.orderNumber,
        'seen': false,
        'date': date,
        'token': token
      });
    });
  }

  void onDelivery() {
    setState(() => isDelivered = true);
    orderRef.doc(widget.orderItems.id).update({
      'delivered': true,
    });
    //Vendor notification
    deliveryVendorNotification();

    //customer notification
    deliveryUserNotification();

    SnackBar snackBar = SnackBar(
        content: Text("Delivery notification sent to ${selectedMerchant[1]} "));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void deliveryRequestNotification() {
    //Get delivery merchant token
    usersReference.doc(selectedMerchant[0]).get().then((value) {
      String token = UserModel.fromDocument(value).token;

      deliveryNotRef.doc(selectedMerchant[0]).collection("Items").doc().set({
        'timestamp': timestamp,
        'body': 'Your have a new delivery request.',
        'orderId': widget.orderItems.orderNumber,
        'seen': 0,
        'date': date,
        'token': token
      });
    });
  }

  deliveryUserNotification() {
    usersReference.doc(widget.orderItems.userId).get().then((value) {
      String token = UserModel.fromDocument(value).token;
      notificationRef
          .doc(widget.orderItems.userId)
          .collection("Items")
          .doc()
          .set({
        'timestamp': timestamp,
        'body': 'Your order with ID:' +
            widget.orderItems.orderNumber +
            ' has been delivered succesfuly.',
        'orderId': widget.orderItems.orderNumber,
        'seen': false,
        'date': date,
        'token': token
      });
    });
  }

  void deliveryVendorNotification() {
    usersReference.doc(widget.orderItems.resId).get().then((value) {
      String token = UserModel.fromDocument(value).token;

      vendorNotRef.doc(widget.orderItems.resId).collection("Items").doc().set({
        'timestamp': timestamp,
        'type': 'delivered',
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
                                  'Order ID: N1947034',
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
                              '${orderItems.length} Items',
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
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
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
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: SizeConfig.screenWidth / 3,
                                  child: Text(
                                    'Restuarant:',
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
                            SizedBox(
                              height: getProportionateScreenHeight(15),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Customer information',
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: SizeConfig.screenWidth / 3,
                                  child: Text(
                                    'Name:',
                                    style: TextStyle(
                                        fontSize: SizeConfig.screenWidth * 0.04,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.screenWidth * 0.5,
                                  child: Text(
                                    customer.name,
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
                                    customer.address,
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
                                    customer.phone,
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
                        height: getProportionateScreenHeight(30),
                      ),
                      widget.screen == "Vendor"
                          ? widget.orderItems.cancelled ? SizedBox.shrink() :
                           Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    'Select delivery merchant',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: SizeConfig.screenWidth * 0.05,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(10),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: ListTile(
                                    onTap: () async {
                                      selectedMerchant = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SelectDeliveryMerchant(
                                                      deliveryMerchants)));
                                      setState(() =>
                                          selectedMerchant = selectedMerchant);
                                    },
                                    dense: true,
                                    contentPadding: EdgeInsets.all(0),
                                    leading: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        child: Icon(
                                          Icons.pedal_bike,
                                          color: Colors.white,
                                        )),
                                    title: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          border: Border.all(
                                              width: 2.0,
                                              color: Colors.grey[200])),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6.0),
                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                selectedMerchant == null
                                                    ? "Delivery merchant"
                                                    : selectedMerchant[1],
                                                style:
                                                    TextStyle(fontSize: 14.0)),
                                            Icon(Icons.keyboard_arrow_right),
                                          ],
                                        )),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                       widget.orderItems.cancelled ? SizedBox.shrink() :
                       Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Order Information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.screenWidth * 0.05,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      widget.orderItems.cancelled ? SizedBox.shrink() :
                       SwitchListTile(
                          value: itemPacked,
                          activeColor: kPrimaryColor,
                          onChanged: (value) {
                            widget.screen == "Vendor" ? orderPacked() : null;
                          },
                          title: Text(
                            'Order Packed',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: SizeConfig.screenWidth * 0.043),
                          )),
                      widget.screen == "Delivery"
                          ? Column(
                              children: [
                                SwitchListTile(
                                    value: isOnTransit,
                                    activeColor: kPrimaryColor,
                                    onChanged: (value) async {
                                      estimatedDeliveryTime =
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddDeliveryTime()));
                                      setState(() => estimatedDeliveryTime =
                                          estimatedDeliveryTime);
                                      if (estimatedDeliveryTime != null) {
                                        onTransit();
                                      } else {
                                        SnackBar snackBar = SnackBar(
                                            content: Text(
                                                "Please set estimated delivery time"));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    },
                                    title: Text(
                                      'Order in transit',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                              SizeConfig.screenWidth * 0.043),
                                    )),
                                SwitchListTile(
                                    value: isDelivered,
                                    activeColor: kPrimaryColor,
                                    onChanged: (value) async {
                                      onDelivery();
                                    },
                                    title: Text(
                                      'Delivered',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                              SizeConfig.screenWidth * 0.043),
                                    )),
                              ],
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class VendourOrderDetailsCard extends StatelessWidget {
  const VendourOrderDetailsCard({
    Key key,
    this.product,
    this.press,
  }) : super(key: key);

  final CartModel product;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        height: SizeConfig.screenHeight * 0.165,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [kDefaultShadow],
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Container(
              height: SizeConfig.screenHeight * 0.165,
              width: getProportionateScreenWidth(118),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(product.image),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: getProportionateScreenHeight(20),
                    width: 41,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(7.0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Color(0XFFFFC107),
                        ),
                        Text(
                          "3.0",
                          style: TextStyle(
                              fontSize: SizeConfig.screenWidth * 0.025,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: getProportionateScreenWidth(10),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 118,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                  fontSize: SizeConfig.screenWidth * 0.042,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).textSelectionColor),
                            ),
                            Text(
                              "package time: " +
                                  product.pTime.toString() +
                                  "mins",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: SizeConfig.screenWidth * 0.034,
                                  color: Theme.of(context).hintColor),
                            ),
                            Text(
                              "Quantity: " + product.quantity.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: SizeConfig.screenWidth * 0.034,
                                  color: Theme.of(context).hintColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    '\N${formatter.format(product.price)}',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Theme.of(context).textSelectionColor),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
