import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/data/model/vendor_model.dart';
import 'package:mealtrips/fooddel/data/repository/order_repo.dart';
import 'package:mealtrips/fooddel/data/repository/user_repo.dart';
import 'package:mealtrips/fooddel/data/repository/vendor_n_repo.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/vendor/edt_profile.dart';
import 'package:mealtrips/fooddel/screens/vendor/my_items.dart';
import 'package:mealtrips/fooddel/screens/vendor/new_item.dart';
import 'package:mealtrips/fooddel/screens/vendor/premium_package.dart';
import 'package:mealtrips/fooddel/screens/profile_picture/profile_picture.dart';
import 'package:mealtrips/fooddel/screens/vendor/vendor_screen.dart';
import 'package:mealtrips/fooddel/screens/vendor/vendor_transaction.dart';
import 'package:mealtrips/fooddel/services/subcrption_checker.dart';
import 'package:mealtrips/fooddel/widgets/bottom_tabs.dart';
import 'package:mealtrips/fooddel/widgets/displayToast.dart';

VendorModel vendor;

class VendorTabs extends StatefulWidget {
  final String userId;
  VendorTabs({this.userId});
  @override
  _HomeTabsState createState() => _HomeTabsState();
}

class _HomeTabsState extends State<VendorTabs> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime backbuttonpressedTime;
  PageController pageController;
  int getPageIndex = 0;
  int exitCount = 0;
  bool isScrollingDown = false;
  int noteCount;
  UserRepo userRepo = UserRepo();
  OrderRepo orderRepo = OrderRepo();
  VendorNRepo vendorNRepo = VendorNRepo();


  @override
  void initState() {
    super.initState();
    getvendorDetails();
     pageController = PageController();
  }

  void getvendorDetails() async {
    vendor = await userRepo.getVendor(widget.userId);
    setState(() => vendor = vendor);
    if (vendor.premium == false) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumPackage(email:vendor.email, name: vendor.name, screen: "", userId:vendor.id,)));
     }else{
      checkSubscription(vendor);
    }
    if (vendor.image == "") {
       Navigator.push(context,MaterialPageRoute(builder: (context) => ProfilePicture(vendor.id,"", "",  1)));
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

  Scaffold buildHomeTabs() {
    return Scaffold(
        key: _scaffoldKey,
        body: PageView(
            children: <Widget>[
              VendorScreen(onlineUser.id),
              NewItem(),
              VendourItems(onlineUser.id),
              VendorTransactions(onlineUser.id),
              VendorProfile(vendor, 'vendor'),
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
            backgroundColor:Theme.of(context).cardColor,
            border: Border(top: BorderSide.none),
            items: [
              bottomTabs(context, Icons.home, "Home"),
              bottomTabs(context,  Icons.add_circle, "Add dish"),
              bottomTabs(context, Icons.food_bank, "Dishes"),
              bottomTabs(context, Icons.monetization_on, "Transactions"),
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
