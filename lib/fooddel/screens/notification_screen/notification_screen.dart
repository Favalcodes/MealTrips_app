import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/data/model/notification_model.dart';
import 'package:mealtrips/fooddel/data/repository/notification_repo.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/widgets/empty_widget.dart';
import 'package:mealtrips/fooddel/screens/widgets/progress_widget.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/size_config.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationRepo nRepo = NotificationRepo();
  List<NotificationModel> notList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getNofication();
  }

  void getNofication() async {
    notList = await nRepo.getNotification(onlineUser.id);
    setState(() => notList = notList);
    setState(() => isLoading = false);
    updateSeen();
  }

  void updateSeen() async {
    notList.forEach((element) {
      notificationRef
          .doc(onlineUser.id)
          .collection("Items")
          .doc(element.id)
          .update({'seen': true});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.screenWidth * 0.04,
          ),
        ),
        elevation:0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).textSelectionColor),
      ),
      body: isLoading
          ? circularProgress()
          : notList.length == 0
              ? Column(
                  children: [
                    SizedBox(height: 100),
                    EmptyWidget(
                      "You don't have a notification.",
                       Icons.notifications,
                      
                  ),
                  ],
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...List.generate(notList.length, (index) {
                          return NotificationItem(
                              title: notList[index].body,
                              date: notList[index].date,
                              isRead: notList[index].seen);
                        })
                      ],
                    ),
                  ),
                ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    Key key,
    this.isRead = true,
    @required this.title,
    @required this.date,
  }) : super(key: key);

  final bool isRead;
  final String title, date;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.notifications_active),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: SizeConfig.screenWidth / 1.3,
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: getProportionateScreenWidth(16),
                          fontWeight:
                              isRead ? FontWeight.w100 : FontWeight.bold,
                          color: isRead
                              ? Theme.of(context).hintColor
                              : Theme.of(context).textSelectionColor),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    date,
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(14),
                        color: Theme.of(context).hintColor),
                  ),
                ],
              ),
              Spacer(),
              if (isRead == false)
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                      color: kPrimaryColor, shape: BoxShape.circle),
                )
            ],
          ),
        ),
        // SizedBox(width: 20,),
        Divider(
          color: Theme.of(context).textSelectionColor.withOpacity(0.4),
        )
      ],
    );
  }
}
