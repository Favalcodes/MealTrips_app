import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/data/model/item_model.dart';
import 'package:mealtrips/fooddel/data/repository/wish_repo.dart';
import 'package:mealtrips/fooddel/screens/food_detail/food_detail.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/widgets/empty_widget.dart';
import 'package:mealtrips/fooddel/screens/widgets/progress_widget.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/size_config.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  WishRepo wishRepo = WishRepo();
  List<ItemModel> wishList;

  @override
  void initState() {
    super.initState();
    getwishList();
  }

  void getwishList() async {
    setState(() => wishList = null);
    wishList = await wishRepo.getWhishes(onlineUser.id);
    setState(() => wishList = wishList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'WishList',
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
        body: wishList == null
            ? circularProgress()
            : wishList.length == 0
                ? Column(
                    children: [
                      SizedBox(height: 100),
                       EmptyWidget(
                            "You don't have any favorites yet.",
                            Icons.favorite,
                        ),
                    ],
                  )
                : ListView.builder(
                    itemCount: wishList.length,
                    itemBuilder: (context, i) {
                      return WishListCard(
                        product: wishList[i],
                        press: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FoodDetail(product: wishList[i]))),
                        callback: getwishList,
                      );
                    }));
  }
}

class WishListCard extends StatelessWidget {
  const WishListCard(
      {Key key, this.product, this.press, this.pressContainer, this.callback})
      : super(key: key);

  final ItemModel product;
  final GestureTapCallback press;
  final GestureTapCallback pressContainer;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pressContainer,
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Container(
              height: SizeConfig.screenHeight * 0.15,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [kDefaultShadow],
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Container(
                    height: SizeConfig.screenHeight * 0.15,
                    width: 118,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(product.image),
                            fit: BoxFit.cover)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          width: 41,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(7.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.star,
                                size: 16,
                                color: Color(0XFFFFC107),
                              ),
                              Text(
                                product.rating.toString(),
                                style: TextStyle(
                                    fontSize: getProportionateScreenWidth(10),
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
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
                              width: getProportionateScreenWidth(111),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.itemName,
                                    style: TextStyle(
                                        fontSize: SizeConfig.screenWidth * 0.04,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .textSelectionColor),
                                  ),
                                  Text(
                                    'package time: ${product.pTime} mins',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize:
                                            SizeConfig.screenWidth * 0.032,
                                        color: Theme.of(context).hintColor),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: getProportionateScreenWidth(50)),
                            GestureDetector(
                                onTap: () => deleteWish(),
                                child: Icon(
                                  Icons.close,
                                  color: Theme.of(context).textSelectionColor,
                                )),
                          ],
                        ),
                        Spacer(),
                        Container(
                        width: 90,
                        child:Text(
                          'N' + formatter.format(product.itemPrice).toString(), overflow:TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: SizeConfig.screenWidth * 0.05,
                          ),
                        )
                         )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 110,
            right: 50,
            child: GestureDetector(
              onTap: press,
              child: Container(
                height: getProportionateScreenHeight(40),
                width: getProportionateScreenHeight(40),
                decoration: BoxDecoration(
                    color: Color(0XFFE73D47),
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(
                  Icons.add_shopping_cart,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void deleteWish() {
    wishRef.doc(onlineUser.id).collection("Items").doc(product.id).delete();
    callback();
  }
}
