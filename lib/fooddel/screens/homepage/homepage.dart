import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/components/drawer.dart';
import 'package:mealtrips/fooddel/data/model/cart_model.dart';
import 'package:mealtrips/fooddel/data/model/item_model.dart';
import 'package:mealtrips/fooddel/data/model/vendor_model.dart';
import 'package:mealtrips/fooddel/data/repository/cart_repo.dart';
import 'package:mealtrips/fooddel/data/repository/item_repo.dart';
import 'package:mealtrips/fooddel/data/repository/user_repo.dart';
import 'package:mealtrips/fooddel/screens/all_resturants/all_resturants.dart';
import 'package:mealtrips/fooddel/screens/all_top_rated/all_top_rated.dart';
import 'package:mealtrips/fooddel/screens/cart/cart_screen.dart';
import 'package:mealtrips/fooddel/screens/category/category_screen.dart';
import 'package:mealtrips/fooddel/screens/food_detail/food_detail.dart';
import 'package:mealtrips/fooddel/screens/homepage/components/category_item.dart';
import 'package:mealtrips/fooddel/screens/homepage/components/food_item.dart';
import 'package:mealtrips/fooddel/screens/homepage/components/restaurant_card.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/restaurant_detail/restaurant_detail.dart';
import 'package:mealtrips/fooddel/screens/widgets/empty_widget.dart';
import 'package:mealtrips/fooddel/screens/widgets/progress_widget.dart';
import 'package:mealtrips/size_config.dart';

int cartItmes = 0;

class HomePage extends StatefulWidget {
  final String screen;
  HomePage({this.screen});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserRepo userRepo = UserRepo();
  ItemRepo itemsRepo = ItemRepo();
  List<CartModel> cartList = [];
  List<ItemModel> recent = [];
  List<ItemModel> topRated = [];

  CartRepo cartRepo = CartRepo();
  List<VendorModel> vendours = [];
  bool isLoading = true;

  final List<Map<String, String>> categories = [
    {"title": "All", "image": "assets/svgs/pastries.svg"},
    {"title": "Lunch", "image": "assets/svgs/launch.svg"},
    {"title": "Break fast", "image": "assets/svgs/breakfast.svg"},
    {"title": "Dinner", "image": "assets/svgs/dinner.svg"},
    {"title": "Smoothies", "image": "assets/svgs/smoothies.svg"},
    {"title": "Cocktails", "image": "assets/svgs/cocktails.svg"},
    {"title": "Salad", "image": "assets/svgs/salad.svg"},
    {"title": "Pastries", "image": "assets/svgs/pastries.svg"},
    {"title": "Fast food", "image": "assets/svgs/fastfood.svg"},
  ];

  @override
  void initState() {
    getVendourDetails();
    getcartList();
    getItems();
    super.initState();
  }

  void getItems() async {
    List<ItemModel> rated;
    recent = await itemsRepo.getitems();
     rated = await itemsRepo.topRated();
    rated.forEach((element) {
      if (element.rating >= 3) {
        topRated.add(element);
      }
    });
    setState(() => topRated = topRated);
    setState(() => recent = recent);
    setState(() => isLoading = false);
  }

  void getVendourDetails() async {
    vendours = await userRepo.getVendors();
    setState(() => vendours = vendours);
  }

  void getcartList() async {
    cartList = await cartRepo.getCart(onlineUser.id);
    setState(() => cartItmes = cartList.length);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text("MealTrips",
            style: TextStyle(color: Theme.of(context).hintColor)),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Container(
              padding: EdgeInsets.only(right: 5.0),
              width: 40,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Stack(
                  overflow: Overflow.visible,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      size: 25,
                      color: Theme.of(context).hintColor,
                    ),
                    cartItmes == 0
                        ? SizedBox.shrink()
                        : Positioned(
                            right: -4,
                            top: -5,
                            child: Container(
                              height: 18,
                              width: 18,
                              decoration: BoxDecoration(
                                  color: kPrimaryColor, shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  cartItmes.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ),
          )
        ],
        backgroundColor: Theme.of(context).cardColor,
        iconTheme: IconThemeData(color: Theme.of(context).hintColor),
      ),
      body: isLoading
          ? circularProgress()
          : recent.length == 0
              ? Column(
                  children: [
                    SizedBox(height: 50),
                    EmptyWidget(
                      "No dish available at the moment.",
                      Icons.food_bank,
                    ),
                  ],
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            //  color: Theme.of(context).cardColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ...List.generate(categories.length, (index) {
                                  return GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CategoryScreen(categories[index]
                                                    ['title']))),
                                    child: CategoryItem(
                                      icon: categories[index]['image'],
                                      title: categories[index]['title'],
                                      index: index,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                        TitleAndMore(
                          title: 'Recent Meals',
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllTopRated(recent, "Recent Meals")));
                          },
                        ),
                        Container(
                          //  color: Theme.of(context).cardColor,
                          child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 2),
                            children: List.generate(
                                recent.length > 6 ? 6 : recent.length, (index) {
                              return FoodItem(
                                items: recent[index],
                                discounted: false,
                                press: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FoodDetail(
                                              product: recent[index])));
                                },
                              );
                            }),
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        TitleAndMore(
                          title: 'Top Rated',
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllTopRated(topRated, "Top Rated")));
                          },
                        ),
                        Container(
                          //  color: Theme.of(context).cardColor,
                          child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 2),
                            children: List.generate(
                                topRated.length > 6 ? 6 : topRated.length,
                                (index) {
                              return FoodItem(
                                items: topRated[index],
                                discounted: false,
                                press: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FoodDetail(
                                              product: topRated[index])));
                                },
                              );
                            }),
                          ),
                        ),
                       
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        TitleAndMore(
                          title: 'Top Restaurant',
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllRestaurants(vendours)));
                          },
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            //color: Theme.of(context).cardColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ...List.generate(vendours.length, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        5, 10, 10, 10),
                                    child: RestaurantCard(
                                      restaurant: vendours[index],
                                      press: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RestaurantDetail(
                                                        restaurant:
                                                            vendours[index])));
                                      },
                                    ),
                                  );
                                })
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class TitleAndMore extends StatelessWidget {
  const TitleAndMore({
    Key key,
    this.title,
    this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor2),
            ),
            GestureDetector(
              onTap: press,
              child: Text(
                'View all',
                style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                    color: kPrimaryColor2),
              ),
            )
          ],
        ),
      ),
    );
  }
}
