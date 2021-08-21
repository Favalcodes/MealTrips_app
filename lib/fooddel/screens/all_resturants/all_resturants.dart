import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/data/model/vendor_model.dart';
import 'package:mealtrips/fooddel/screens/restaurant_detail/restaurant_detail.dart';
import 'package:mealtrips/size_config.dart';

class AllRestaurants extends StatefulWidget {
  final List<VendorModel> restuarant;
  AllRestaurants(this.restuarant);
  @override
  _AllRestaurantsState createState() => _AllRestaurantsState();
}

class _AllRestaurantsState extends State<AllRestaurants> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Restaurants',
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...List.generate(widget.restuarant.length, (index) {
                return AllRestaurantsCard(
                  restaurant: widget.restuarant[index],
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RestaurantDetail(
                                  restaurant: widget.restuarant[index],
                                )));
                  },
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}

class AllRestaurantsCard extends StatelessWidget {
  const AllRestaurantsCard({
    Key key,
    this.press,
    @required this.restaurant,
  }) : super(key: key);

  final GestureTapCallback press;
  final VendorModel restaurant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: press,
        child: Container(
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.0),
              color: Theme.of(context).cardColor,
              boxShadow: [kDefaultShadow]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: getProportionateScreenHeight(100),
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(7.0),
                        topLeft: Radius.circular(7.0)),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(restaurant.image),
                        fit: BoxFit.cover)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: getProportionateScreenHeight(29),
                      width: 41,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(7.0))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Color(0XFFFFC107),
                          ),
                          Text(
                            restaurant.rating.toStringAsFixed(1),
                            style: TextStyle(
                                fontSize: getProportionateScreenWidth(12),
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(5),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              restaurant.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: SizeConfig.screenWidth * 0.04,
                                  color: Theme.of(context).textSelectionColor),
                            ),
                          ),
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
                                restaurant.address,
                                maxLines: 2,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: getProportionateScreenWidth(16)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    // Text(
                    //  "N400",
                    //   style: TextStyle(
                    //       fontSize: getProportionateScreenWidth(17),
                    //       fontWeight: FontWeight.bold,
                    //       color: Theme.of(context).textSelectionColor
                    //   ),
                    // )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
