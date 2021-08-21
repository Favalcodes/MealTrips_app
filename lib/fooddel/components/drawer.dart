import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/my_orders/my_orders.dart';
import 'package:mealtrips/fooddel/screens/personal_information/personal_information.dart';
import 'package:mealtrips/fooddel/screens/splash_screen/splash_screen.dart';
import 'package:mealtrips/fooddel/screens/terms/terms.dart';
import 'package:mealtrips/fooddel/services/Authentication.dart';
import 'package:mealtrips/size_config.dart';
import 'package:mealtrips/theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerWidget extends StatefulWidget {
  _DrawerWidget createState() => _DrawerWidget();
}

class _DrawerWidget extends State<DrawerWidget> {
  bool _light = false;
  AuthImplementation auth = Auth();

  _switchFunction(bool value) {
    setState(() {
      _light = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50.0),
            onlineUser == null
                ? SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PersonalInformation())),
                      child: Row(
                        children: [
                          Container(
                            height: getProportionateScreenHeight(70),
                            width: getProportionateScreenHeight(70),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      onlineUser.image),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 200,
                                child: Text(
                                  onlineUser.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:16,
                                      color:
                                          Theme.of(context).textSelectionColor),
                                ),
                              ),
                              // SizedBox(height: 5,),
                              Text(
                                onlineUser.email,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: SizeConfig.screenWidth * 0.035,
                                    color: Theme.of(context).hintColor),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            ListTile(
              title: Text("My Order", style:TextStyle(fontSize:13.0)),
              leading: Icon(Icons.food_bank),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyOrders())),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            Divider(
              color: Color(0XFFC4C4C4),
              thickness: 0.7,
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile", style:TextStyle(fontSize:13.0)),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PersonalInformation())),
            ),
            Divider(
              color: Color(0XFFC4C4C4),
              thickness: 0.7,
            ),
            ListTile(
              leading: Icon(Icons.chat_bubble),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text("WhatsApp", style:TextStyle(fontSize:13.0)),
              onTap: () => launchURL("https://wa.me/message/CCE4OTV5W7EOO1"),
            ),
            Divider(
              color: Color(0XFFC4C4C4),
              thickness: 0.7,
            ),
            ListTile(
              leading: Icon(Icons.mail),
              title: Text("Contact us", style:TextStyle(fontSize:13.0)),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => _launchMail(),
            ),
            Divider(
              color: Color(0XFFC4C4C4),
              thickness: 0.7,
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Terms and condition", style:TextStyle(fontSize:13.0)),
              trailing: Icon(Icons.keyboard_arrow_right),
               onTap:()=> Navigator.push(context, MaterialPageRoute(builder: (context) => TermsCondtions())),
            ),
            Divider(
              color: Color(0XFFC4C4C4),
              thickness: 0.7,
            ),
            ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout", style:TextStyle(fontSize:13.0)),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () async {

                  //Turn off dark mode
                  if(themeProvider.isDarkMode){
                    final provider = Provider.of<ThemeProvider>(context, listen: false);
                     provider.toggleTheme(false);
                  }

                  await auth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => SplashScreen()),
                      (Route<dynamic> route) => false);
                
                }
                
                ),
            Divider(
              color: Color(0XFFC4C4C4),
              thickness: 0.7,
            ),
           
            ListTile(
              title: SwitchListTile(
                title: Text(
                  'Dark Mode',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
                value: themeProvider.isDarkMode,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  final provider = Provider.of<ThemeProvider>(context, listen: false);
                  provider.toggleTheme(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchMail() async {
    final Uri params = Uri(
      scheme: "mailto",
      path: "mealtrips@gmail.com",
      query: "subject=MealTrips 1.0.0",
    );
    final url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not lanch" + url;
    }
  }

  launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not luanch " + url;
    }
  }
}
