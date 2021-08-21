import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/data/model/vendor_model.dart';
import 'package:mealtrips/fooddel/data/repository/order_repo.dart';
import 'package:mealtrips/fooddel/data/repository/user_repo.dart';
import 'package:mealtrips/fooddel/screens/delivery/delivery_screen.dart';
import 'package:mealtrips/fooddel/screens/delivery/edit_profile.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/widgets/bottom_tabs.dart';




class DeliveryTabs extends StatefulWidget {
  @override
  _HomeTabsState createState() => _HomeTabsState();
}

class _HomeTabsState extends State<DeliveryTabs> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime backbuttonpressedTime;
  PageController pageController;
  int getPageIndex = 0;
  int exitCount = 0;
  bool isScrollingDown = false;
  UserRepo userRepo = UserRepo();
  OrderRepo orderRepo = OrderRepo();
  VendorModel delivery;


  @override
  void initState() {
    super.initState();
    getdeliveryDetails();
     pageController = PageController();
  }

 
  void getdeliveryDetails() async {
    delivery = await userRepo.getDelivery(onlineUser.id);
    setState(() => delivery = delivery);
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

  Scaffold buildHomeTabs() {
    return Scaffold(
        key: _scaffoldKey,
        body: PageView(
            children: <Widget>[
              DeliveryScreen(),
              DeliveryProfile(),
            ],
            controller: pageController,
            onPageChanged: whenPageChanges,
            physics: NeverScrollableScrollPhysics()),
        bottomNavigationBar: Material(
          elevation: 4.0,
          child: CupertinoTabBar(
            currentIndex: getPageIndex,
            onTap: onTapChangePage,
            activeColor:kPrimaryColor2,
            inactiveColor: Theme.of(context).hintColor,
            backgroundColor: Colors.white,
            border: Border(top: BorderSide.none),
            items: [
              bottomTabs(context, Icons.home, "Home"),

              bottomTabs(context, Icons.person, "Profile"),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return buildHomeTabs();
  }
}
