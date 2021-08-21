import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/components/customNavBar.dart';
import 'package:mealtrips/fooddel/components/default_buttons.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/size_config.dart';

class PersonalInformation extends StatelessWidget {
  final TextEditingController nameTextController =
      TextEditingController(text: onlineUser.name);
  final TextEditingController phoneTextController =
      TextEditingController(text: onlineUser.phone);
  final TextEditingController addressTextController =
      TextEditingController(text: onlineUser.address);

  void updateInfo(BuildContext context) {
    Navigator.pop(
      context,
    );
    usersReference.doc(onlineUser.id).update({
      "address": addressTextController.text,
      "phone": phoneTextController.text,
      "name": nameTextController.text,
    });

    SnackBar snackBar = SnackBar(content: Text("Profile updated"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Personal information',
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
      bottomNavigationBar: CustomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            PersonalInfoDiv(
              title: 'Personal Information',
              press: () => addMediaModal(context),
            ),
            SizedBox(
              height: getProportionateScreenHeight(15),
            ),
            PersonalInfoBox(title: 'Full name', desc: onlineUser.name),
            SizedBox(
              height: getProportionateScreenHeight(15),
            ),
            PersonalInfoBox(
              title: 'Mobile number',
              desc: onlineUser.phone,
            ),
            SizedBox(
              height: getProportionateScreenHeight(15),
            ),
            PersonalInfoBox(
              title: 'Delivery Address',
              desc: onlineUser.address,
            ),
          ],
        ),
      ),
    );
  }

  addMediaModal(context) {
    TextFormField buildNameFormField(context) {
      return TextFormField(
        keyboardType: TextInputType.text,
        controller: nameTextController,
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Full name',
          suffixIcon: Icon(Icons.label),
          labelText: 'Name',
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
              borderSide:
                  BorderSide(color: Theme.of(context).textSelectionColor),
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

    TextFormField buildPhoneFormField(context) {
      return TextFormField(
        keyboardType: TextInputType.text,
        controller: phoneTextController,
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Phone number',
          suffixIcon: Icon(Icons.label),
          labelText: 'Phone',
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
              borderSide:
                  BorderSide(color: Theme.of(context).textSelectionColor),
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

    TextFormField buildAddressFormField(context) {
      return TextFormField(
        keyboardType: TextInputType.text,
        controller: addressTextController,
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Delivery Address',
          suffixIcon: Icon(Icons.label),
          labelText: 'Address',
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
              borderSide:
                  BorderSide(color: Theme.of(context).textSelectionColor),
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

    showModalBottomSheet<dynamic>(
        // isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              // height: SizeConfig.screenHeight /1.7,
              padding: EdgeInsets.symmetric(
                vertical: 15,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [kDefaultShadow],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Column(
                      //  crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal information',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.screenWidth * 0.05),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(20),
                        ),
                        buildNameFormField(context),
                        SizedBox(
                          height: getProportionateScreenHeight(20),
                        ),
                        buildPhoneFormField(context),
                        SizedBox(
                          height: getProportionateScreenHeight(20),
                        ),
                        buildAddressFormField(context),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  DefaultButton(
                    text: 'Save',
                    press: () => updateInfo(context),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class PersonalInfoBox extends StatelessWidget {
  const PersonalInfoBox({
    Key key,
    this.title,
    this.desc,
  }) : super(key: key);

  final String title, desc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        // height: SizeConfig.screenHeight *0.08,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.screenWidth * 0.032,
                  color: Theme.of(context).textSelectionColor),
            ),
            Text(
              desc,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.screenWidth * 0.04,
                  color: Theme.of(context).textSelectionColor),
            )
          ],
        ),
      ),
    );
  }
}

class PersonalInfoDiv extends StatelessWidget {
  const PersonalInfoDiv({
    Key key,
    this.title,
    this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: SizeConfig.screenWidth * 0.05,
                fontWeight: FontWeight.w500),
          ),
          GestureDetector(
            onTap: press,
            child: Text(
              'Update',
              style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
