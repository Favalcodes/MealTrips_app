import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/data/model/user_model.dart';
import 'package:mealtrips/fooddel/data/repository/user_repo.dart';
import 'package:mealtrips/fooddel/screens/admin/admin_tab.dart';
import 'package:mealtrips/fooddel/screens/delivery/delivery_tab.dart';
import 'package:mealtrips/fooddel/screens/delivery/notification.dart';
import 'package:mealtrips/fooddel/screens/explore/explore.dart';
import 'package:mealtrips/fooddel/screens/homepage/homepage.dart';
import 'package:mealtrips/fooddel/screens/notification_screen/notification_screen.dart';
import 'package:mealtrips/fooddel/screens/vendor/notifcation.dart';
import 'package:mealtrips/fooddel/screens/vendor/vendor_tab.dart';
import 'package:mealtrips/fooddel/screens/wishlist/wishlist.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/fooddel/widgets/bottom_tabs.dart';

UserModel onlineUser;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true
    );

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class HomeTabs extends StatefulWidget {
  final String screen;
  HomeTabs({this.screen});
  @override
  _HomeTabsState createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime backbuttonpressedTime;
  PageController pageController;
  int getPageIndex = 0;
  int exitCount = 0;
  bool isScrollingDown = false;
  int noteCount;
  UserRepo userRepo = UserRepo();
  bool isLoading = true;

  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        if (message.data['navigation'] == "/customer") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NotificationScreen()));
        } else if (message.data['navigation'] == "/vendor") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => VendorNotification()));
        } else if (message.data['navigation'] == "/delivery") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DeliveryNotification()));
        }
      }
    });
    super.initState();
    fetchUserInfo();
    pageController = PageController();
  }

  void fetchUserInfo() async {
    onlineUser = await userRepo.getUser(context);
    updateUserToken(onlineUser);
    setState(() => onlineUser = onlineUser);
    if (onlineUser.email == "mealtrips@gmail.com") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => AdminTab()),
          (Route<dynamic> route) => false);
    } else {
      if (widget.screen == "Vendor") {
        //Allow vendor shopping
      } else {
        //go vendor dashboard
        if (onlineUser.type == 1) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => VendorTabs()),
              (Route<dynamic> route) => false);
        } else if (onlineUser.type == 2) {
          //go to delivery merchant dashboard
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => DeliveryTabs()),
              (Route<dynamic> route) => false);
        }
      }
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void whenPageChanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  void onTapChangePage(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 400), curve: Curves.bounceInOut);
  }

  void updateUserToken(UserModel onlineUser) {
    firebaseMessaging.getToken().then((token) {
      usersReference.doc(onlineUser.id).update({'token': token});
    });
  }

  Scaffold buildHomeTabs() {
    return Scaffold(
      key: _scaffoldKey,
      body: PageView(
          children: <Widget>[
            HomePage(),
            Explore(),
            WishList(),
            NotificationScreen(),
          ],
          controller: pageController,
          onPageChanged: whenPageChanges,
          physics: NeverScrollableScrollPhysics()),
      bottomNavigationBar: Material(
        elevation: 4.0,
        child: CupertinoTabBar(
          currentIndex: getPageIndex,
          onTap: onTapChangePage,
          activeColor: kPrimaryColor2,
          inactiveColor: Theme.of(context).hintColor,
          backgroundColor: Theme.of(context).cardColor,
          border: Border(top: BorderSide.none),
          items: [
            bottomTabs(context, Icons.home, "Home"),
            bottomTabs(context, Icons.explore, "Search"),
            bottomTabs(context, Icons.favorite, "WishList"),
            bottomTabs(context, Icons.notifications, "Notifications"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildHomeTabs();
  }
}
