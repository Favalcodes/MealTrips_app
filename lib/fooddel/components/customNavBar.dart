import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/screens/explore/explore.dart';
import 'package:mealtrips/fooddel/screens/homepage/homepage.dart';
import 'package:mealtrips/fooddel/screens/notification_screen/notification_screen.dart';
import 'package:mealtrips/fooddel/screens/wishlist/wishlist.dart';
import 'package:mealtrips/size_config.dart';

class CustomNavBar extends StatefulWidget {
  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int selectedMenu;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> navBarData = [
      {
        "icon": Icons.home,
        "title": "Home",
      },
      {
        "icon": Icons.explore,
        "title": "Search",
      },
      {
        "icon": Icons.favorite,
        "title": "WishList",
      },
      {
        "icon": Icons.notifications,
        "title": "notifications",
      },
    ];
    return Container(
      width: double.infinity,
      height: SizeConfig.screenHeight * 0.073,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [kDefaultShadow],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ...List.generate(navBarData.length, (index) {
          return NavBarItem(
              icon: navBarData[index]['icon'],
              title: navBarData[index]['title'],
              iconColor: selectedMenu == index
                  ? kPrimaryColor
                  : Theme.of(context).hintColor,
              textColor: selectedMenu == index
                  ? kPrimaryColor
                  : Theme.of(context).hintColor,
              press: () {
                setState(() {
                  selectedMenu = index;
                });
                if (selectedMenu == 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                } else if (selectedMenu == 1) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Explore()));
                } else if (selectedMenu == 2) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WishList()));
                } else if (selectedMenu == 3) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()));
                }
              });
        })
      ]),
    );
  }
}

class NavBarItem extends StatelessWidget {
  const NavBarItem({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.press,
    this.iconColor,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final GestureTapCallback press;
  final Color iconColor, textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: press,
        child: Column(
          children: [
            Icon(icon, color: iconColor),
            SizedBox(
              height: 3,
            ),
            Text(
              title,
              style: TextStyle(
                  color: textColor, fontSize: SizeConfig.screenWidth * 0.021),
            )
          ],
        ),
      ),
    );
  }
}
