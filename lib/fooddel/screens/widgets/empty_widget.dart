import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import '../../../size_config.dart';

class EmptyWidget extends StatelessWidget {
  final String title;
  final IconData icon;

  EmptyWidget(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 120.0, color: Colors.grey[300]),
           Text(
              title, textAlign:TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color:Theme.of(context).hintColor),
            ),
            SizedBox(height: 5.0,),
           
            OutlineButton(
              onPressed: () {
                SnackBar snackBar = SnackBar(content: Text("Refreshing..."));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },

              child: Text("Refresh"),
              textColor:kPrimaryColor2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
            ),
          ],
        ),
      ),
    );
  }
}
