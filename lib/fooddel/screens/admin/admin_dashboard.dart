import 'package:flutter/material.dart';
import 'package:mealtrips/fooddel/data/repository/user_repo.dart';
import 'package:mealtrips/fooddel/screens/admin/total_users.dart';



class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List category = ["Vendors", "Delivery", "Users"];
  TabController _tabController;
  UserRepo userRepo = UserRepo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Admin Dashboard"),
      ),
      body: DefaultTabController(
          length: category.length,
          child: Column(children: [
            Container(
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                indicatorPadding: EdgeInsets.all(0),
                unselectedLabelColor: Colors.black87,
                labelColor: Colors.white,
                indicatorColor: Colors.red,
                indicatorWeight: 6.0,
                tabs: category.map((tab) => tabs(tab)).toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children:
                      category.map((tabBar) => tabBarView(tabBar)).toList()),
            ),
          ])),
    );
  }

  Widget tabBarView(tab) {
    return TotalUsers(tab);
  }

  Tab tabs(tab) {
    return Tab(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Text(tab,
          style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.w600)),
    ));
  }
}
