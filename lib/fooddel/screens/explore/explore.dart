import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/components/default_buttons.dart';
import 'package:mealtrips/fooddel/data/model/item_model.dart';
import 'package:mealtrips/fooddel/data/model/vendor_model.dart';
import 'package:mealtrips/fooddel/data/repository/user_repo.dart';
import 'package:mealtrips/fooddel/screens/homepage/components/restaurant_card.dart';
import 'package:mealtrips/fooddel/screens/restaurant_detail/restaurant_detail.dart';
import 'package:mealtrips/fooddel/screens/vendor/new_item.dart';
import 'package:mealtrips/fooddel/screens/food_detail/food_detail.dart';
import 'package:mealtrips/fooddel/screens/homepage/components/food_item.dart';
import 'package:mealtrips/fooddel/screens/widgets/empty_widget.dart';
import 'package:mealtrips/fooddel/screens/widgets/progress_widget.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/size_config.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  TextEditingController searchFormFiled = TextEditingController();
  bool isLoading = false;
  List<ItemModel> dataList = [];
  List<ItemModel> itemSearchResult = [];
  List<ItemModel> filterHolder = [];
  List<ItemModel> itemList = [];
  bool startSearch = false;
  UserRepo userRepo = UserRepo();
  bool food = true;
  bool vendor = false;
  String labelText = "What do you want to eat?";
  List<VendorModel> vendorSearchResult = [];
  List<VendorModel> vendors = [];
  int itemCount = 0;
//handle search

  void controlSearch(String query) async {
    query = toBeginningOfSentenceCase(query);
    if (query.length > 1) {
      setState(() {
        isLoading = true;
        startSearch = true;
        itemSearchResult = [];
        vendorSearchResult = [];
        dataList = [];
      });

      if (food) {
        //Search for food
        if (itemList.length == 0) {
          QuerySnapshot querySnapshot = await itemsRef.get();
          itemList = querySnapshot.docs
              .map((documentSnapshot) =>
                  ItemModel.fromDocument(documentSnapshot))
              .toList();
        }
        itemList.forEach((element) {
          String itemName = toBeginningOfSentenceCase(element.itemName);
          if (itemName.startsWith(query)) {
            itemSearchResult.add(element);
          }
        });

        Timer(Duration(seconds: 1), () {
          setState(() {
            itemList = itemList;
            itemSearchResult = itemSearchResult;
            dataList = itemSearchResult;
            itemCount = itemSearchResult.length;
            isLoading = false;
          });
        });
      } else {
        //Search for vendor
        if (vendors.length == 0) {
          QuerySnapshot querySnapshot = await resturantRef.get();

          vendors = querySnapshot.docs
              .map((documentSnapshot) =>
                  VendorModel.fromDocument(documentSnapshot))
              .toList();
        }

        vendors.forEach((element) {
          String vendorName = toBeginningOfSentenceCase(element.name);
          if (vendorName.startsWith(query)) {
            vendorSearchResult.add(element);
          }
        });

        Timer(Duration(seconds: 1), () {
          setState(() {
            vendors = vendors;
            vendorSearchResult = vendorSearchResult;
            itemCount = vendorSearchResult.length;
            isLoading = false;
          });
        });
      }
    } else {
      setState(() {
        itemSearchResult = [];
        dataList = [];
        itemCount = 0;
        isLoading = false;
      });
    }
  }

  emptyFormField() {
    searchFormFiled.clear();
  }

  //filter search
  void filterSearch(String query) async {
    setState(() {
      isLoading = true;
      filterHolder = [];
      itemSearchResult = [];
    });

    dataList.forEach((element) {
      //  RegExp regExp = RegExp("\\b" + query + "\\b", caseSensitive: false);

      RegExp regExp = RegExp("\\b" + query + "\\b", caseSensitive: false);

      if (regExp.hasMatch(element.category)) {
        filterHolder.add(element);
      }

      // if (element.category == query) {
      //   filterHolder.add(element);
      // }

      setState(() {
        itemSearchResult = filterHolder;
        itemCount = itemSearchResult.length;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Explore',
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.screenWidth * 0.04,
          ),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).textSelectionColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    height: SizeConfig.screenHeight * 0.07,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Theme.of(context).hintColor,
                        ),
                        SizedBox(width: 3),
                        Expanded(
                            flex: 2,
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              onChanged: controlSearch,
                              decoration: InputDecoration(
                                hintText: labelText,
                                hintStyle: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: SizeConfig.screenWidth * 0.04,
                                    fontWeight: FontWeight.w300),
                                border: InputBorder.none,
                              ),
                            )),
                        vendor
                            ? SizedBox.shrink()
                            : IconButton(
                                icon: Icon(
                                  Icons.filter_list,
                                  color: Theme.of(context).hintColor,
                                ),
                                onPressed: () {
                                  addMediaModal(context);
                                })
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                                value: food,
                                activeColor: kPrimaryColor,
                                onChanged: (value) {
                                  setState(() => food = true);
                                  setState(() => vendor = false);
                                  setState(() => itemCount = 0);
                                  setState(() => itemSearchResult = []);
                                  setState(() =>
                                      labelText = "What do you want to eat?");
                                }),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text("Food",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                                value: vendor,
                                activeColor: kPrimaryColor,
                                onChanged: (value) {
                                  setState(() => food = false);
                                  setState(() => vendor = true);
                                  setState(() => itemCount = 0);
                                  setState(() => vendorSearchResult = []);
                                  setState(() =>
                                      labelText = "Find your favorite vendor.");
                                }),
                            Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text("Vendor",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)))
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            isLoading
                ? circularProgress()
                : !startSearch
                    ? Text("")
                    : itemCount == 0
                        ? Column(
                            children: [
                              SizedBox(height: 50),
                              EmptyWidget(
                                "Search not found, please try a different keyword.",
                                Icons.search,
                              ),
                            ],
                          )
                        : Container(
                            color: Theme.of(context).cardColor,
                            child: GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              childAspectRatio:
                                  MediaQuery.of(context).size.width /
                                      (MediaQuery.of(context).size.height / 2),
                              children: List.generate(
                                  food
                                      ? itemSearchResult.length
                                      : vendorSearchResult.length, (index) {
                                return food
                                    ? FoodItem(
                                        items: itemSearchResult[index],
                                        discounted: false,
                                        press: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FoodDetail(
                                                          product:
                                                              itemSearchResult[
                                                                  index])));
                                        },
                                      )
                                    : RestaurantCard(
                                        restaurant: vendorSearchResult[index],
                                        press: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RestaurantDetail(
                                                          restaurant:
                                                              vendorSearchResult[
                                                                  index])));
                                        },
                                      );
                              }),
                            ),
                          ),
          ],
        ),
      ),
    );
  }

  addMediaModal(context) {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              height: SizeConfig.screenHeight / 1.5,
              padding: EdgeInsets.symmetric(vertical: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [kDefaultShadow],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter by',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.screenWidth * 0.05),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(50),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Category',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.screenWidth * 0.04),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      height: 150.0,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 15.0,
                            childAspectRatio: 2),
                        itemCount: categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(31),
                                  border: Border.all(
                                    color: Theme.of(context).hintColor,
                                  )),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    String query = categories[index]['title'];
                                    filterSearch(query);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    categories[index]['title'],
                                    style: TextStyle(
                                      fontSize: SizeConfig.screenWidth * 0.04,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  DefaultButton(
                    press: () {},
                    text: 'Filter',
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: getProportionateScreenHeight(60),
                      width: 75 / 100 * SizeConfig.screenWidth,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          borderRadius: BorderRadius.circular(40)),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: getProportionateScreenWidth(19),
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
