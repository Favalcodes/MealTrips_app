import 'package:flutter/material.dart';
import 'package:mealtrips/fooddel/data/model/delivery_notification_model.dart';
import 'package:mealtrips/fooddel/data/repository/delivery_n_repo.dart';
import 'package:mealtrips/fooddel/screens/delivery/delivery_screen.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/widgets/empty_widget.dart';
import 'package:mealtrips/fooddel/screens/widgets/progress_widget.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';

import '../../../size_config.dart';

class DeliveryNotification extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<DeliveryNotification> {

  DeliveryNRepo deliveryNRepo = DeliveryNRepo();
  List<DeliveryNModel> notList = [];
  List<DeliveryNModel> newNotList = [];

  @override
  void initState() {
    super.initState();
    getNofication();
  }

 
  
  void getNofication() async {
    notList = await deliveryNRepo.getNotification(onlineUser.id);
    notList.forEach((element) {
      if (element.seen == 0) {
         deliveryNotRef
          .doc(delivery.id)
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
         backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).textSelectionColor),
        title:  Text(
          'Delivery Notification',
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.screenWidth * 0.04,
          ),
        ),
      ),
        body:notList == null
            ? circularProgress()
            :notList.length == 0
                ? Column(
                    children: [
                      SizedBox(height: 50),
                     EmptyWidget(
                      "You don't have a notification at the moment.",
                      Icons.notifications,
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount:notList.length,
                    itemBuilder: (context, i) {
                      return Card(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          dense: true,
                          leading: CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.pedal_bike,
                                color: Colors.white,
                              )),
                          title: Text("Order ID: " +notList[i].orderId),
                          subtitle: Text(notList[i].body),
                          trailing: Text(notList[i].date),
                        ),
                      ));
                    }));
  }
}
