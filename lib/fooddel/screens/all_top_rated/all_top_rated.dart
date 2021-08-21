import 'package:flutter/material.dart';
import 'package:mealtrips/fooddel/data/model/item_model.dart';
import 'package:mealtrips/fooddel/screens/food_detail/food_detail.dart';
import 'package:mealtrips/fooddel/screens/homepage/components/food_item.dart';
import 'package:mealtrips/size_config.dart';

class AllTopRated extends StatefulWidget {
  final List<ItemModel> items;
  final String title;
  AllTopRated(this.items, this.title);
  @override
  _AllTopRatedState createState() => _AllTopRatedState();
}

class _AllTopRatedState extends State<AllTopRated> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontWeight: FontWeight.bold,
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
        children: List.generate(widget.items.length, (index) {
          return FoodItem(
            items: widget.items[index],
            discounted: false,
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FoodDetail(product: widget.items[index])));
            },
          );
        }),
      )),
    );
  }
}
