import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/components/review_box.dart';
import 'package:mealtrips/fooddel/data/model/cart_model.dart';
import 'package:mealtrips/fooddel/data/repository/cart_repo.dart';
import 'package:mealtrips/fooddel/data/repository/wish_repo.dart';
import 'package:mealtrips/fooddel/screens/cart/cart_screen.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/homepage/homepage.dart';
import 'package:mealtrips/fooddel/screens/reviews/reviews_screen.dart';
import 'package:mealtrips/fooddel/screens/vendor/vendor_tab.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/fooddel/widgets/check_out_modal.dart';
import 'package:mealtrips/fooddel/widgets/rating_modal.dart';
import 'package:mealtrips/size_config.dart';
import 'package:mealtrips/fooddel/data/model/item_model.dart';

class FoodDetail extends StatelessWidget {
  final ItemModel product;
  final String view;
  FoodDetail({@required this.product, this.view});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Body(
      product: product,
      view: view,
    ));
  }
}

class Body extends StatefulWidget {
  final ItemModel product;
  final String view;
  Body({@required this.product, this.view});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<CartModel> cartList = [];
  CartRepo cartRepo = CartRepo();
  double price;
  WishRepo wishRepo = WishRepo();
  List<ItemModel> wishList;
  List<String> wishIds = [];
  bool wish = false;
  bool canDelete = false;

  void getwishList() async {
    setState(() => wishList = null);
    wishList = await wishRepo.getWhishes(onlineUser.id);

    wishList.forEach((element) {
      wishIds.add(element.id);
    });

    if (wishIds.contains(widget.product.id)) {
      setState(() => wish = true);
    }

    setState(() => wishList = wishList);
  }

  void deleteItem() {
    itemsRef.doc(widget.product.id).delete();
    SnackBar snackBar = SnackBar(content: Text("Item deleted"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>VendorTabs()));
  }

  @override
  void initState() {
    super.initState();
    getcartList();
    getwishList();
    price = widget.product.itemPrice;
    if (widget.view == "vendor" && onlineUser.id == widget.product.resId) {
      setState(() {
        canDelete = true;
      });
    }
  }

  void getcartList() async {
    cartList = await cartRepo.getCart(onlineUser.id);
    setState(() => cartList = cartList);
  }

  int no = 1;

  void decrement() {
    if (no > 1) {
      setState(() {
        no--;
        price = widget.product.itemPrice * no;
      });
    }
  }

  void increment() {
    setState(() {
      no++;
      price = widget.product.itemPrice * no;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              overflow: Overflow.visible,
              children: [
                Container(
                  height: 45 / 100 * SizeConfig.screenHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              CachedNetworkImageProvider(widget.product.image),
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
                                size: 20,
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
                                    size: 22,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  cartItmes == 0
                                      ? SizedBox.shrink()
                                      : Positioned(
                                          right: -7,
                                          top: -5,
                                          child: Container(
                                            height: 18,
                                            width: 18,
                                            decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                shape: BoxShape.circle),
                                            child: Center(
                                              child: Text(
                                                cartItmes.toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                ),
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
                  padding: const EdgeInsets.only(top: 280),
                  child: Container(
                      width: SizeConfig.screenWidth,
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: getProportionateScreenWidth(15),
                              right: getProportionateScreenWidth(15),
                              left: getProportionateScreenWidth(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width:
                                              getProportionateScreenWidth(200),
                                          child: Text(
                                            widget.product.itemName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize:
                                                    SizeConfig.screenWidth *
                                                        0.06,
                                                color: Theme.of(context)
                                                    .textSelectionColor),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Vendor : ',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .hintColor),
                                            ),
                                            Text(
                                              "${widget.product.vendorName}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  //  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .hintColor),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Package time: " +
                                              widget.product.pTime +
                                              " mins",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                                  SizeConfig.screenWidth * 0.04,
                                              color:
                                                  Theme.of(context).hintColor),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Color(0XFFFFC107),
                                          size: getProportionateScreenWidth(28),
                                        ),
                                        Text(
                                          widget.product.rating
                                              .toStringAsFixed(1),
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(18),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(10),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: getProportionateScreenWidth(150),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () => decrement(),
                                            child: Container(
                                              height:
                                                  getProportionateScreenHeight(
                                                      51),
                                              width:
                                                  getProportionateScreenWidth(
                                                      55),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: kPrimaryColor
                                                      .withOpacity(0.21)),
                                              child: Center(
                                                child: Text(
                                                  '-',
                                                  style: TextStyle(
                                                      fontSize:
                                                          getProportionateScreenWidth(
                                                              22),
                                                      color: Theme.of(context)
                                                          .hintColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            no.toString(),
                                            style: TextStyle(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        23),
                                                color: Theme.of(context)
                                                    .hintColor),
                                          ),
                                          GestureDetector(
                                            onTap: () => increment(),
                                            child: Container(
                                              height:
                                                  getProportionateScreenHeight(
                                                      51),
                                              width:
                                                  getProportionateScreenWidth(
                                                      55),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: kPrimaryColor
                                                      .withOpacity(0.21)),
                                              child: Center(
                                                child: Text(
                                                  '+',
                                                  style: TextStyle(
                                                      fontSize:
                                                          getProportionateScreenWidth(
                                                              22),
                                                      color: Theme.of(context)
                                                          .hintColor),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'N' + formatter.format(price).toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(15),
                                ),
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: SizeConfig.screenWidth * 0.05,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    widget.product.description,
                                    style: TextStyle(
                                      fontSize: SizeConfig.screenWidth * 0.038,
                                    ),
                                  ),
                                ),
                                TitleAndMore(
                                  title: 'Reviews',
                                  press: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ReviewScreen(
                                                widget.product.id, 'item')));
                                  },
                                ),
                                ReviewBox(widget.product.id, '', () {
                                  if (widget.product.rateId[onlineUser.id] !=
                                      true) {
                                    ratingModal(context);
                                  } else {
                                    SnackBar snackBar = SnackBar(
                                        content: Text(
                                            "You can only rate an item once."));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }, 'item'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(15),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  addToWishList(widget.product);
                                  setState(() {
                                    wish = true;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Container(
                                      height: getProportionateScreenHeight(60),
                                      width: 17 / 100 * SizeConfig.screenWidth,
                                      decoration: BoxDecoration(
                                          color: Color(0XFFE73D47)
                                              .withOpacity(0.26),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: wish
                                          ? Icon(
                                              Icons.favorite,
                                              size: getProportionateScreenWidth(
                                                  30),
                                              color: Color(0XFFE73D47),
                                            )
                                          : Icon(
                                              Icons.favorite_border,
                                              size: getProportionateScreenWidth(
                                                  30),
                                              color: Color(0XFFE73D47),
                                            )),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  addMediaModal(context);
                                  addTocart(widget.product.id, no, widget.product);
                                },
                                child: Container(
                                  height: getProportionateScreenHeight(60),
                                  width: 75 / 100 * SizeConfig.screenWidth,
                                  decoration: BoxDecoration(
                                      color: kPrimaryColor2,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40),
                                          bottomLeft: Radius.circular(40))),
                                  child: Center(
                                    child: Text(
                                      'Add to Cart',
                                      style: TextStyle(
                                          fontSize:
                                              getProportionateScreenWidth(19),
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          !canDelete
                              ? SizedBox.shrink()
                              : GestureDetector(
                                  onTap: () {
                                    deleteItem();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: getProportionateScreenHeight(60),
                                    width: 75 / 100 * SizeConfig.screenWidth,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: kPrimaryColor,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: Center(
                                      child: Text(
                                        'Delete Item',
                                        style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(18),
                                            color: kPrimaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void addToWishList(ItemModel itemModel) {
    wishRef.doc(onlineUser.id).collection("Items").doc(itemModel.id).set({
      'resId': itemModel.id,
      'itemName': itemModel.itemName,
      'pTime': itemModel.pTime,
      'vendorName': itemModel.vendorName,
      'itemPrice': itemModel.itemPrice,
      'timestamp': timestamp,
      'category': itemModel.category,
      'image': itemModel.image,
      'rateId': {},
      'description': itemModel.description,
      'totalOrder': 0,
      'discount': 0,
      'rating': 0.0
    });
    SnackBar snackBar = SnackBar(content: Text("Item added to wishlist"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  ratingModal(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return RatingModal(
            widget.product.id,
            'null',
            "item",
          );
        });
  }

  void addTocart(String id, int no, ItemModel itemModel) {
    setState(() => cartItmes = cartItmes + 1);
    double totalPrice = no * double.parse(itemModel.itemPrice.toString());
    cartRef.doc().set({
      'itemId': id,
      'resId': itemModel.resId,
      'userId': onlineUser.id,
      'timestamp': timestamp,
      'quantity': no,
      'price': totalPrice,
      'name': itemModel.itemName,
      'image': itemModel.image,
      'pTime': itemModel.pTime
    });

    //Add to frequesntly orderd meal
    int totalOrder = itemModel.totalOrder + 1;

    itemsRef.doc(id).update({'totalOrder': totalOrder});
  }
}
