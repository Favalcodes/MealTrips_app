import 'package:flutter/material.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/homepage/homepage.dart';
import 'package:mealtrips/fooddel/screens/splash_screen/splash_screen.dart';
import 'package:mealtrips/fooddel/screens/unboard/unboard_screen.dart';
import 'package:mealtrips/fooddel/services/Authentication.dart';
import 'package:mealtrips/size_config.dart';

class MappingScreen extends StatefulWidget {
  @override
  _MappingScreenState createState() => _MappingScreenState();
}

enum AuthStatus { notSignedIn, signedIn, isLoading }

class _MappingScreenState extends State<MappingScreen> {
  AuthStatus authStatus = AuthStatus.isLoading;
  int isDynamicLink = 0;
  String sharedUrl = "";
  AuthImplementation auth = Auth();

  @override
  void initState() {
    super.initState();
    handleView();
  }

  //handle view to be displayed to the user
  void handleView() async {
    auth.isSignedIn().then((user) {
      setState(() {
        authStatus =
            user == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    //display view based on user credential
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new SplashScreen();
        break;
      case AuthStatus.isLoading:
        return new UnboardScreen();
        break;
      case AuthStatus.signedIn:
        return new HomeTabs(screen:"",);
        break;
    }
    return null;
  }
}
