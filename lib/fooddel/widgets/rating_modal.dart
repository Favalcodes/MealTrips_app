import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/components/default_buttons.dart';
import 'package:mealtrips/fooddel/data/model/item_model.dart';
import 'package:mealtrips/fooddel/data/model/rating_model.dart';
import 'package:mealtrips/fooddel/data/model/vendor_model.dart';
import 'package:mealtrips/fooddel/data/repository/item_repo.dart';
import 'package:mealtrips/fooddel/data/repository/user_repo.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/reviews/reviews_screen.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/size_config.dart';

class RatingModal extends StatefulWidget {
  final String itemId;
  final String resId;
  final String screen;
  RatingModal(this.itemId, this.resId, this.screen);

  @override
  _RatingModalState createState() => _RatingModalState();
}

class _RatingModalState extends State<RatingModal> {
  TextEditingController textEditingController = TextEditingController();
  UserRepo userRepo = UserRepo();
  ItemRepo itemRepo = ItemRepo();
  VendorModel vendor;
  ItemModel item;
  int stars = -1;

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  void getDetails() async {
    vendor = await userRepo.getVendor(widget.resId);
    item = await itemRepo.itemDetails(widget.itemId);
    setState(() {
      vendor = vendor;
      item = item;
    });
  }

  void rateDish(int points, String review, String itemId) {
    List<RatingModel> revewsList;
    double totalRates = 0;
    double averageRate = 0;

    itemsRatingRef.doc(itemId).collection("Items").get().then((value) {
      revewsList = value.docs
          .map((document) => RatingModel.fromDocument(document))
          .toList();
      revewsList.forEach((element) {
        totalRates = totalRates + element.rating;
      });

      averageRate = (totalRates + points) / (revewsList.length + 1);

      itemsRef.doc(itemId).update({
        'rating': averageRate,
      });
    });
    points = points + 1;

    itemsRatingRef.doc(itemId).collection("Items").doc().set({
      'userId': onlineUser.id,
      'rating': points,
      'review': review,
      'date': date,
      'username': onlineUser.name,
      'profileImage': onlineUser.image,
      'timestamp': timestamp,
    });
    itemsRef.doc(itemId).update({"rateId.${onlineUser.id}": true});

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ReviewScreen(itemId, 'item')));
  }

  void rateRes(points, String review, String resId) {
    List<RatingModel> revewsList;
    double totalRates = 0;
    double averageRate = 0;

    resRatingRef.doc(resId).collection("Items").get().then((value) {
      revewsList = value.docs
          .map((document) => RatingModel.fromDocument(document))
          .toList();

      revewsList.forEach((element) {
        totalRates = totalRates + element.rating;
      });

      averageRate = (totalRates + points) / (revewsList.length + 1);

      //update dish rating
      resturantRef.doc(resId).update({
        'rating': averageRate,
      });
    });
    points = points + 1;
    resRatingRef.doc(resId).collection("Items").doc().set({
      'userId': onlineUser.id,
      'rating': points,
      'review': review,
      'timestamp': timestamp,
      'date': date,
      'username': onlineUser.name,
      'profileImage': onlineUser.image,
    });

    resturantRef.doc(resId).update({"rateId.${onlineUser.id}": true});

    Navigator.push(context,MaterialPageRoute(builder: (context) => ReviewScreen(resId, 'res')));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: SizeConfig.screenHeight / 2,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [kDefaultShadow],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Column(
          children: [
            SizedBox(
              height: 60.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => stars = index),
                    child: Icon(
                      Icons.star,
                      color: stars >= index ? kPrimaryColor : Colors.grey,
                      size: 40.0,
                    ),
                  );
                }),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(3),
            ),
            Text(
              'Tap on star to rate',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            stars < 0
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: buildReviewFormField(context),
                  ),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            DefaultButton(
              press: () async {
                Navigator.pop(context);
                if (stars > -1) {
                  if (textEditingController.text.length > 1) {
                    if (widget.screen == 'item') {
                     
                        rateDish(stars, textEditingController.text, widget.itemId);
                     
                    } else {
                          rateRes( stars, textEditingController.text, widget.resId);
                    }
                  } else {
                    SnackBar snackBar =
                        SnackBar(content: Text("Please add review."));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                } else {
                  SnackBar snackBar =
                      SnackBar(content: Text("Please tap on star to rate."));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              text: 'Submit',
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                if (widget.screen == 'item') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ReviewScreen(widget.itemId, 'item')));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ReviewScreen(widget.resId, 'res')));
                }
              },
              child: Container(
                height: getProportionateScreenHeight(60),
                width: 75 / 100 * SizeConfig.screenWidth,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: kPrimaryColor2,
                    ),
                    borderRadius: BorderRadius.circular(40)),
                child: Center(
                  child: Text(
                    'View rate',
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(18),
                        color: kPrimaryColor2),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextFormField buildReviewFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: textEditingController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Add Review',
        suffixIcon: Icon(Icons.label),
        labelText: 'Review',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Theme.of(context).hintColor),
            gapPadding: 0),
        focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Theme.of(context).textSelectionColor),
            gapPadding: 0),
        errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(20)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
      ),
    );
  }

}
