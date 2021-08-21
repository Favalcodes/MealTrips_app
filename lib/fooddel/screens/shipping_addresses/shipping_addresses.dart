import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/screens/shipping_addresses/add_address.dart';
import 'package:mealtrips/size_config.dart';

class ShippingAddresses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Shipping addresses',
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
          children: [
            AddressBox(
              address: '4517 Washington Ave. Manchester, Kentucky 39495',
              isSelected: true,
            ),
            AddressBox(
              address: '3 Newbridge Court Chino Hills, CA 91709, United States',
            ),
            AddressBox(
              address: '51 Riverside Chino Hills, CA 91709, United States',
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddAddress()));
                    },
                    child: Container(
                      width: getProportionateScreenHeight(55),
                      height: getProportionateScreenHeight(55),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.21),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.add,
                        color: kPrimaryColor,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddressBox extends StatelessWidget {
  const AddressBox({
    Key key,
    @required this.address,
    this.isSelected = false,
  }) : super(key: key);

  final String address;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        width: double.infinity,
        // height: SizeConfig.screenHeight * 0.17,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                      fontSize: SizeConfig.screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textSelectionColor),
                ),
                Text(
                  'Edit',
                  style: TextStyle(
                      fontSize: SizeConfig.screenWidth * 0.032,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor),
                )
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            SizedBox(
              width: SizeConfig.screenWidth / 1.6,
              child: Text(
                address,
                style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 0.037,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textSelectionColor),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Row(
              children: [
                Container(
                  height: getProportionateScreenHeight(20),
                  width: getProportionateScreenHeight(20),
                  decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Theme.of(context).colorScheme.secondary)),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.surface,
                          size: 12,
                        )
                      : Container(),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(5),
                ),
                Text(
                  'Use as the shipping address',
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 0.04,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
