import 'package:flutter/material.dart';
import 'package:mealtrips/size_config.dart';

class DefaultAppBar extends StatelessWidget {
  final String appBarTitle;

  DefaultAppBar({this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        appBarTitle,
        style: TextStyle(
          color: Theme.of(context).textSelectionColor,
          fontWeight: FontWeight.w400,
          fontSize: SizeConfig.screenWidth * 0.04,
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Theme.of(context).textSelectionColor),
    );
  }
}
