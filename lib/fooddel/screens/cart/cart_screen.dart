import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/components/default_buttons.dart';
import 'package:mealtrips/fooddel/data/model/cart_model.dart';
import 'package:mealtrips/fooddel/data/repository/cart_repo.dart';
import 'package:mealtrips/fooddel/screens/check_out/check_out.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/homepage/homepage.dart';
import 'package:mealtrips/fooddel/screens/widgets/empty_widget.dart';
import 'package:mealtrips/fooddel/screens/widgets/progress_widget.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/size_config.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartRepo cartRepo = CartRepo();
  List<CartModel> cartList = [];
  double totalPrice = 0.0;
  int deliveryFee = 0;
  double totalAmount = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getcartList();
  }

  void getcartList() async {
    setState(() => cartList = []);

    setState(() => totalPrice = 0.0);

    setState(() => totalAmount = 0.0);

    await cartRepo.getCart(onlineUser.id).then((value) {
      getDeliveryFee(value);
    });

    cartList = await cartRepo.getCart(onlineUser.id);

    cartList.forEach((element) {
      totalPrice = totalPrice + element.price;
    });

    setState(() => totalAmount = totalPrice + deliveryFee);

    setState(() => totalPrice = totalPrice);
    setState(() => cartList = cartList);
    setState(() => cartItmes = cartList.length);
    setState(() => isLoading = false);
  }

//calculate delivery fee, charge extra N100 if odering from other vendor
  void getDeliveryFee(List<CartModel> list) {
    final List<CartModel> filterVendor = list;
    var ids = filterVendor.map((e) => e.resId).toSet();
    filterVendor.retainWhere((x) => ids.remove(x.resId));
    int res = filterVendor.length - 1;
    deliveryFee = (res * 100) + 500;
    setState(() => deliveryFee = deliveryFee);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Cart',
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
          : cartList.length == 0
              ? Column(
                  children: [
                    SizedBox(height: 100),
                    EmptyWidget(
                      "Your cart is empty, please add an item.",
                      Icons.shopping_cart,
                    ),
                  ],
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: cartList.length,
                              itemBuilder: (context, i) {
                                return CartItem(cartList[i], getcartList);
                              }),
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total Items',
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.screenWidth * 0.04,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .textSelectionColor),
                                      ),
                                      Text(
                                        'N${formatter.format(totalPrice)}',
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.screenWidth * 0.04,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .textSelectionColor),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: getProportionateScreenWidth(10),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Delivery fee',
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.screenWidth * 0.04,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .textSelectionColor),
                                      ),
                                      Spacer(),
                                      Text(
                                        'N${formatter.format(deliveryFee)}',
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.screenWidth * 0.04,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .textSelectionColor),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(15),
                                ),
                                Divider(
                                  color: Theme.of(context).hintColor,
                                  thickness: 1,
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(10),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Total',
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.screenWidth * 0.04,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .textSelectionColor),
                                      ),
                                      Spacer(),
                                      Text(
                                        'N${formatter.format(totalAmount)}',
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.screenWidth * 0.04,
                                            fontWeight: FontWeight.w600,
                                            color: kPrimaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(40),
                          ),
                          DefaultButton(
                            press: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckOut(
                                          cartList, totalAmount, deliveryFee)));
                            },
                            text: 'Continue',
                          )
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}

class CartItem extends StatefulWidget {
  final CartModel item;
  final VoidCallback callback;
  CartItem(this.item, this.callback);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  void removeFromCart() {
    cartRef.doc(widget.item.id).delete();
    widget.callback();
    SnackBar snackBar = SnackBar(content: Text("Item removed from Cart"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        height: SizeConfig.screenHeight * 0.165,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [kDefaultShadow],
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Container(
              height: SizeConfig.screenHeight * 0.165,
              width: getProportionateScreenWidth(118),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.item.image),
                      fit: BoxFit.cover)),
            ),
            SizedBox(
              width: getProportionateScreenHeight(10),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: getProportionateScreenWidth(118),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.name,
                              style: TextStyle(
                                  fontSize: SizeConfig.screenWidth * 0.045,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).textSelectionColor),
                            ),
                            Text(
                              'Package Time: 2 mins',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: SizeConfig.screenWidth * 0.035,
                                  color: Theme.of(context).hintColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(60),
                      ),
                      GestureDetector(
                          onTap: () => removeFromCart(),
                          child: Icon(
                            Icons.close,
                            color: Theme.of(context).hintColor,
                          )),
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: getProportionateScreenWidth(90),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: getProportionateScreenWidth(30),
                              child: Center(
                                child: Text(
                                  'Quantity:  ',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Text(
                              widget.item.quantity.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(60),
                      ),
                      Container(
                          width: 60,
                          child: Text(
                            'N' +
                                formatter.format(widget.item.price).toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
