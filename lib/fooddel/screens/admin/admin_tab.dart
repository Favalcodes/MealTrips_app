import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/screens/admin/admin_dashboard.dart';
import 'package:mealtrips/fooddel/screens/admin/delivery_earnings.dart';
import 'package:mealtrips/fooddel/screens/admin/edt_profile.dart';
import 'package:mealtrips/fooddel/screens/admin/extra_delivery_earnings.dart';
import 'package:mealtrips/fooddel/screens/admin/order_overview.dart';
import 'package:mealtrips/fooddel/screens/admin/premiun_package.dart';
import 'package:mealtrips/fooddel/widgets/bottom_tabs.dart';



class AdminTab extends StatefulWidget {
  final String screen;
  AdminTab({this.screen});
  @override
  _HomeTabsState createState() => _HomeTabsState();
}

class _HomeTabsState extends State<AdminTab> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime backbuttonpressedTime;
  PageController pageController;
  int getPageIndex = 0;
  int exitCount = 0;
  bool isScrollingDown = false;
  int noteCount;
  bool isLoading = true;

  

  @override
  void initState() {
    super.initState();
    pageController = PageController();
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
              AdminDashboard(),
              DeliveryEarningsScreen(),
              ExtraDeliveryEarningsScreen(),
              OrderOverview(),
              UpdatePremiumPlan(),
              AdminProfile(),
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
              bottomTabs(context, Icons.group, "Users"),
              bottomTabs(context, Icons.pedal_bike, "Delivery"),
              bottomTabs(context, CupertinoIcons.money_dollar, "Earnings"),
              bottomTabs(context, Icons.food_bank, "Order"),
              bottomTabs(context, Icons.monetization_on, "Premium"),
              bottomTabs(context, Icons.person, "Admin"),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return buildHomeTabs();
  }

}
