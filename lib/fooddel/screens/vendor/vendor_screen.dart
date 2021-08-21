import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealtrips/fooddel/data/model/order_model.dart';
import 'package:mealtrips/fooddel/data/model/vendor_notification_model.dart';
import 'package:mealtrips/fooddel/data/repository/order_repo.dart';
import 'package:mealtrips/fooddel/data/repository/user_repo.dart';
import 'package:mealtrips/fooddel/data/repository/vendor_n_repo.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/vendor/notifcation.dart';
import 'package:mealtrips/fooddel/screens/vendor/order_details.dart';
import 'package:mealtrips/fooddel/screens/vendor/premium_package.dart';
import 'package:mealtrips/fooddel/screens/profile_picture/photo_preview.dart';
import 'package:mealtrips/fooddel/screens/profile_picture/profile_picture.dart';
import 'package:mealtrips/fooddel/screens/my_orders/my_orders.dart';
import 'package:mealtrips/fooddel/screens/vendor/vendor_tab.dart';
import 'package:mealtrips/fooddel/screens/widgets/empty_widget.dart';
import 'package:mealtrips/fooddel/services/subcrption_checker.dart';
import 'package:mealtrips/fooddel/utility/colorResources.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/fooddel/utility/style.dart';
import 'package:cached_network_image/cached_network_image.dart';



class VendorScreen extends StatefulWidget {
  final String userId;
  VendorScreen(this.userId);
  @override
  _VendorScreenState createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  UserRepo userRepo = UserRepo();
  OrderRepo orderRepo = OrderRepo();
  List<OrderModel> orderList = [];
  List<OrderModel> myOrderList = [];
  VendorNRepo vendorNRepo = VendorNRepo();
  List<VendorNModel> notList = [];
  List<VendorNModel> newNotList = [];

  @override
  void initState() {
    super.initState();
    getVendorDetails();
    getNofication();
  }

  void getNofication() async {
    notList = await vendorNRepo.getNotification(widget.userId);
    notList.forEach((element) {
      if (element.seen == 0) {
        newNotList.add(element);
      }
    });
    setState(() => newNotList = newNotList);
    setState(() => notList = notList);
  }

  void getVendorDetails() async {
    vendor = await userRepo.getVendor(widget.userId);
    setState(() => vendor = vendor);
    getOrderList();
    if (vendor.premium == false) {
       Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) =>PremiumPackage(
            email: vendor.email,
            name: vendor.name,
            screen: "",
            userId: vendor.id,
          )),
        (Route<dynamic> route) => false);
    } else {
      checkSubscription(vendor);
    }
    if (vendor.image == "") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePicture(vendor.id, "", "", 1)));
    }
  }

  void getOrderList() async {
    orderList = await orderRepo.getOrder();
    orderList.forEach((element) {
      if (element.resId == vendor.id) {
        myOrderList.add(element);
      }
    });
    setState(() => myOrderList = myOrderList);
  }

  @override
  Widget build(BuildContext context) {
     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ));
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: 7,
            child: Container(
              color: Theme.of(context).accentColor,
              width: MediaQuery.of(context).size.width,
              height: 250.0,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Vendor",
                          style: poppinsBold.copyWith(
                              fontSize: 20, color: ColorResources.COLOR_WHITE)),
                      Row(
                        children: [
                        //  GestureDetector(
                        //    onTap:()=> Navigator.of(context).push(
                        //             MaterialPageRoute(
                        //                 builder: (context)=> HomeTabs(screen:"Vendor"))),
                        //    child: Icon(Icons.shopping_cart, color: Colors.white)
                        //    ),
                         SizedBox(width:5.0),
                          Stack(
                            overflow: Overflow.visible,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VendorNotification())),
                                child: Icon(Icons.notifications,
                                    size: 30,
                                    color: ColorResources.COLOR_WHITE),
                              ),
                              newNotList.length == 0
                                  ? SizedBox.shrink()
                                  : Positioned(
                                      right: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: ColorResources
                                                  .COLOR_DARK_ORCHID
                                                  .withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 10,
                                              offset: Offset(0,
                                                  1), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: 8,
                                          backgroundColor:
                                              ColorResources.COLOR_WHITE,
                                          child: Text(
                                              newNotList.length.toString(),
                                              style: TextStyle(fontSize: 8)),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
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
                            Container(
                              padding: EdgeInsets.only(left: 20, top: 20),
                              child: Row(
                                children: [
                                  vendor.image == ""
                                      ? avatar()
                                      : CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 32,
                                          child: CircleAvatar(
                                              radius: 30.0,
                                              backgroundColor: Colors.white,
                                              child: Hero(
                                                  tag: vendor.image,
                                                  child: GestureDetector(
                                                    onTap: () => photoPreview(
                                                        context,
                                                        vendor.image),
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          CachedNetworkImageProvider(
                                                              vendor.image),
                                                      radius: 40.0,
                                                      backgroundColor:
                                                          Colors.grey[300],
                                                    ),
                                                  ))),
                                        ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(vendor.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14.0,
                                                color: Colors.white)),
                                        Text(vendor.address,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w100,
                                                color: Colors.white54)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            myOrderList.length == 0
                                ? Column(
                                    children: [
                                      SizedBox(height: 200),
                                       EmptyWidget(
                                        "No food has been orderd from this vendor yet.r",
                                        Icons.food_bank,
                                     ),
                                    ],
                                  )
                                : Container(
                                    margin: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 20,
                                          offset: Offset(3,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 5, top: 19, right: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Recent Order",
                                                  textAlign: TextAlign.left,
                                                ),
                                                ListView.builder(
                                                    itemCount:
                                                        myOrderList.length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemBuilder: (context, i) {
                                                      return MyOrderCard(
                                                        isDelivered:
                                                            myOrderList[i]
                                                                .delivered,
                                                        orderNo:
                                                            'Order ID: ${myOrderList[i].orderNumber}',
                                                        date: myOrderList[i]
                                                            .date
                                                            .toString(),
                                                        trackingNo:
                                                            'IW3475453455',
                                                        quantity: myOrderList[i]
                                                            .quantity
                                                            .toString(),
                                                        amount:
                                                            formatter.format(
                                                                myOrderList[i]
                                                                    .amount),
                                                        status: myOrderList[i]
                                                                .delivered
                                                            ? 'Delivered'
                                                            : myOrderList[i]
                                                                    .cancelled
                                                                ? "Cancelled"
                                                                : "Processing",
                                                        press: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          VendourOrderDetails(
                                                                            orderItems:
                                                                                myOrderList[i],
                                                                            screen:
                                                                                "Vendor",
                                                                          )));
                                                        },
                                                      );
                                                    })
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
          )
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

  photoPreview(BuildContext context, String photo) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhotoPreview(photo)));
  }
}
