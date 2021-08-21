import 'package:flutter/material.dart';
import 'package:mealtrips/fooddel/data/model/item_model.dart';
import 'package:mealtrips/fooddel/data/repository/item_repo.dart';
import 'package:mealtrips/fooddel/screens/food_detail/food_detail.dart';
import 'package:mealtrips/fooddel/screens/homepage/components/food_item.dart';
import 'package:mealtrips/fooddel/screens/widgets/empty_widget.dart';
import 'package:mealtrips/size_config.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  CategoryScreen(this.category);
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  ItemRepo itemsRepo = ItemRepo();

  List<ItemModel> items = [];

  @override
  void initState() {
    super.initState();
    getItems();
  }

  void getItems() async {
    items = await itemsRepo.catItems(widget.category);
    setState(() => items = items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.category + " Category",
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
      body: items.length == 0
          ?  EmptyWidget(
                "No dish found in this category.",
                Icons.food_bank,
              
            )
          : SafeArea(
              child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 2),
              children: List.generate(items.length, (index) {
                return FoodItem(
                  items: items[index],
                  discounted: false,
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FoodDetail(product: items[index])));
                  },
                );
              }),
            )),
    );
  }
}
