import 'package:flutter/material.dart';
import 'package:mealtrips/fooddel/data/model/item_model.dart';
import 'package:mealtrips/fooddel/data/repository/item_repo.dart';
import 'package:mealtrips/fooddel/screens/food_detail/food_detail.dart';
import 'package:mealtrips/fooddel/screens/homepage/components/food_item.dart';
import 'package:mealtrips/fooddel/screens/widgets/empty_widget.dart';
import 'package:mealtrips/fooddel/screens/widgets/progress_widget.dart';
import 'package:mealtrips/size_config.dart';

class VendourItems extends StatefulWidget {
  final String resId;
  VendourItems(this.resId);
  @override
  _VendourItemsState createState() => _VendourItemsState();
}

class _VendourItemsState extends State<VendourItems> {
  List<ItemModel> items = [];
  ItemRepo itemsRepo = ItemRepo();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getItems();
  }

  void getItems() async {
    items = await itemsRepo.resturantItems(widget.resId);
    setState(() => items = items);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Dishes',
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
      body: isLoading
          ? circularProgress()
          : items.length == 0
              ? Column(
                  children: [
                    SizedBox(height: 200),
                    EmptyWidget(
                        "You are yet to upload a dish.",
                        Icons.food_bank,
                      
                    ),
                  ],
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
                                    FoodDetail(product: items[index], view:"vendor",)));
                      },
                    );
                  }),
                )),
    );
  }
}
