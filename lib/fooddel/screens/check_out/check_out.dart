import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/components/default_buttons.dart';
import 'package:mealtrips/fooddel/data/model/cart_model.dart';
import 'package:mealtrips/fooddel/models/delivery_method.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/shipping_addresses/add_address.dart';
import 'package:mealtrips/fooddel/screens/widgets/progress_widget.dart';
import 'package:mealtrips/fooddel/services/payment_service.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/size_config.dart';

class CheckOut extends StatefulWidget {
  final List<CartModel> catList;
  final double totalAmount;
  final int deliveryFee;
  CheckOut(this.catList, this.totalAmount, this.deliveryFee);
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  String address;
  int selectedIndex;
  bool isLoading = false;
  String selectedDeliveryMethod = "";

  @override
  void initState() {
    super.initState();
    address = onlineUser.address;
    initializeSdk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Check out',
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontWeight: FontWeight.w400,
            fontSize: SizeConfig.screenWidth * 0.04,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).textSelectionColor),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery address',
                    style: TextStyle(
                        fontSize: SizeConfig.screenWidth * 0.05,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textSelectionColor),
                  ),
                  GestureDetector(
                    onTap: () async {
                      address = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddAddress()));
                      setState(() => address = address);
                    },
                    child: Text(
                      'Update',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor2),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                width: SizeConfig.screenWidth / 1.5,
                child: Text(
                  address == "" ? "Update delivery address" : address,
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 0.04,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(15),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Padding(
              padding: EdgeInsets.only(right: 50, left: 50.0),
              child: Row(
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                        fontSize: SizeConfig.screenWidth * 0.04,
                        fontWeight: FontWeight.w700),
                  ),
                  Spacer(),
                  Text(
                    'N' + formatter.format(widget.totalAmount).toString(),
                    style: TextStyle(
                        fontSize: SizeConfig.screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            isLoading
                ? circularProgress()
                : Center(
                    child: DefaultButton(
                      press: () {
                        setState(() => isLoading = true);
                        if (address == "") {
                          SnackBar snackBar = SnackBar(
                              content: Text("Please update delivery address"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }else{
                          initPayment(context, widget.catList, onlineUser.name, widget.totalAmount, onlineUser.email, widget.deliveryFee);
                        }
                        setState(() => isLoading = false);
                      },
                      text: 'Place my order',
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class DeliveryMethodSelector extends StatelessWidget {
  const DeliveryMethodSelector({
    Key key,
    this.deliveryMethods,
    this.containerColor,
    this.press,
  }) : super(key: key);

  final DeliveryMethods deliveryMethods;
  final Color containerColor;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: GestureDetector(
          onTap: press,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).hintColor),
                    ),
                  ),
                  Positioned(
                    top: 2.5,
                    left: 2.5,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: containerColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: getProportionateScreenWidth(15),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deliveryMethods.title,
                    style: TextStyle(
                        fontSize: SizeConfig.screenWidth * 0.042,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(3),
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth / 2,
                    child: Text(
                      deliveryMethods.subTitle,
                      style: TextStyle(
                          fontSize: SizeConfig.screenWidth * 0.034,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              Spacer(),
              // Text(
              //   deliveryMethods.amount,
              //   style: TextStyle(
              //       fontSize: SizeConfig.screenWidth * 0.04,
              //       fontWeight: FontWeight.w600),
              // )
            ],
          ),
        ));
  }
}
