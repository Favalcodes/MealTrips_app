import 'package:flutter/material.dart';
import 'package:mealtrips/fooddel/data/model/item_model.dart';
import 'package:mealtrips/fooddel/models/product.dart';
import 'package:mealtrips/fooddel/screens/homepage/components/food_item.dart';
import 'package:mealtrips/size_config.dart';

class AllSpecialOffers extends StatefulWidget {
  @override
  _AllSpecialOffersState createState() => _AllSpecialOffersState();
}

class _AllSpecialOffersState extends State<AllSpecialOffers> {
  List<ItemModel> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Special Offers',
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontWeight: FontWeight.w400,
            fontSize: SizeConfig.screenWidth * 0.04,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).textSelectionColor),
      ),
      body: SafeArea(
          child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 2),
        children: List.generate(demoProducts.length, (index) {
          return FoodItem(
            items: items[index],

            /// press: () { Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetail(product: demoProducts[index])));
            //},)
          );
        }),
      )),
    );
  }
}
