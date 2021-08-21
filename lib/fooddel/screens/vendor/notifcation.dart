import 'package:flutter/material.dart';
import 'package:mealtrips/fooddel/data/model/vendor_notification_model.dart';
import 'package:mealtrips/fooddel/data/repository/vendor_n_repo.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/vendor/vendor_tab.dart';
import 'package:mealtrips/fooddel/screens/widgets/empty_widget.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/size_config.dart';

class VendorNotification extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<VendorNotification> {
  VendorNRepo vendorNRepo = VendorNRepo();
  List<VendorNModel> notList = [];
  List<VendorNModel> newNotList = [];
  @override
  void initState() {
    super.initState();
    getNofication();
  }

  void getNofication() async {
    notList = await vendorNRepo.getNotification(onlineUser.id);
    notList.forEach((element) {
      if (element.seen == 0) {
        vendorNotRef
            .doc(vendor.id)
            .collection("Items")
            .doc(element.id)
            .update({'seen': 1});
      }
    });
    setState(() => notList = notList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Vendor Notification',
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
        body: notList.length == 0
            ? Column(
                children: [
                  SizedBox(height: 100),
                  EmptyWidget(
                    "You don't have a notification.",
                    Icons.notifications,
                  ),
                ],
              )
            : ListView.builder(
                itemCount: notList.length,
                itemBuilder: (context, i) {
                  return Card(
                      child: ListTile(
                    title: Text("Order ID: " + notList[i].orderId),
                    subtitle: Text(notList[i].type == 'order'
                        ? "New order recieved" : notList[i].type == 'cancelled' ? "Order cancelled by customer"
                        : "Order delivered successfully."),
                  ));
                }));
  }
}
