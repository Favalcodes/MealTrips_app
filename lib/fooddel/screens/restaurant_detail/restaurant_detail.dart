import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/components/customNavBar.dart';
import 'package:mealtrips/fooddel/components/review_box.dart';
import 'package:mealtrips/fooddel/data/model/cart_model.dart';
import 'package:mealtrips/fooddel/data/model/item_model.dart';
import 'package:mealtrips/fooddel/data/model/vendor_model.dart';
import 'package:mealtrips/fooddel/data/repository/cart_repo.dart';
import 'package:mealtrips/fooddel/data/repository/item_repo.dart';
import 'package:mealtrips/fooddel/screens/vendor/my_items.dart';
import 'package:mealtrips/fooddel/screens/cart/cart_screen.dart';
import 'package:mealtrips/fooddel/screens/food_detail/food_detail.dart';
import 'package:mealtrips/fooddel/screens/homepage/components/food_item.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/homepage/homepage.dart';
import 'package:mealtrips/fooddel/screens/reviews/reviews_screen.dart';
import 'package:mealtrips/fooddel/widgets/rating_modal.dart';
import 'package:mealtrips/size_config.dart';

class RestaurantDetail extends StatefulWidget {
  RestaurantDetail({this.restaurant});
  final VendorModel restaurant;

  @override
  _RestaurantDetailState createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  ItemRepo itemsRepo = ItemRepo();
  List<ItemModel> items = [];

  List<VendorModel> vendours = [];
  List<CartModel> cartList = [];
  CartRepo cartRepo = CartRepo();

  void getcartList() async {
    cartList = await cartRepo.getCart(onlineUser.id);
    setState(() => cartList = cartList);
  }

  @override
  void initState() {
    super.initState();
    getItems();
    getcartList();
  }

  void getItems() async {
    items = await itemsRepo.resturantItems(widget.restaurant.id);
    setState(() => items = items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomNavBar(),
        body: SafeArea(
          child: ListView(
            children: [
              Container(
                height: 30 / 100 * SizeConfig.screenHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            CachedNetworkImageProvider(widget.restaurant.image),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 38,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_ios_sharp,
                              size: 22,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartScreen()));
                        },
                        child: Container(
                          width: 38,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Stack(
                              overflow: Overflow.visible,
                              children: [
                                Icon(
                                  Icons.shopping_cart,
                                  size: 20,
                                  color: Theme.of(context).hintColor,
                                ),
                                cartItmes < 1
                                    ? SizedBox.shrink()
                                    : Positioned(
                                        right: -7,
                                        top: -5,
                                        child: Container(
                                          height: 13,
                                          width: 13,
                                          decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              shape: BoxShape.circle),
                                          child: Center(
                                            child: Text(
                                              cartItmes.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      SizeConfig.screenWidth *
                                                          0.02,
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
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 100,
                              child: Text(
                                widget.restaurant.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ),
                            // SizedBox(
                            //   width: SizeConfig.screenWidth / 2.3,
                            //   child: Text(
                            //     "restaurant.foodType",
                            //     style: TextStyle(
                            //         fontWeight: FontWeight.w400,
                            //         fontSize: getProportionateScreenWidth(16)),
                            //   ),
                            // ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Color(0XFFFFC107),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              widget.restaurant.rating.toStringAsFixed(1),
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(16),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            // Text(
                            //   'Rating number',
                            //   style: TextStyle(
                            //       fontSize: getProportionateScreenWidth(13),
                            //       fontWeight: FontWeight.w500),
                            // )
                          ],
                        )
                        // Text(
                        //   "Price",
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: getProportionateScreenWidth(26)),
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: kPrimaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth / 2,
                          child: Text(
                            widget.restaurant.address,
                            maxLines: 2,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: getProportionateScreenWidth(16)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.phone,
                          color: kPrimaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth / 2,
                          child: Text(
                            widget.restaurant.phone,
                            maxLines: 2,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: getProportionateScreenWidth(16)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TitleAndMore(
                      title: 'Reviews',
                      press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReviewScreen(widget.restaurant.id, 'res')));
                      },
                    ),
                    ReviewBox(widget.restaurant.id, '', () {
                       if(widget.restaurant.rateId[onlineUser.id] != true){
                         if(widget.restaurant.userOrder[onlineUser.id] == true){
                              ratingModal(context);
                         }else{
                            SnackBar snackBar = SnackBar(
                            content: Text("Please order a meal from this vendor before adding review."));
                           ScaffoldMessenger.of(context).showSnackBar(snackBar);
                         }
                        }else{
                          SnackBar snackBar = SnackBar(content:Text("You can only rate a vendor once."));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                    }, 'res'),
                  ],
                ),
              ),
              TitleAndMore(
                title: 'Restaurant menu',
                press: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            VendourItems(widget.restaurant.id))),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(items.length, (index) {
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
                    })
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  ratingModal(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return RatingModal(
            '',
            widget.restaurant.id,
            "res",
          );
        });
  }
}
