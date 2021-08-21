import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/fooddel/components/default_buttons.dart';
import 'package:mealtrips/fooddel/data/model/vendor_model.dart';
import 'package:mealtrips/fooddel/screens/profile_picture/photo_preview.dart';
import 'package:mealtrips/fooddel/screens/profile_picture/profile_picture.dart';
import 'package:mealtrips/fooddel/screens/splash_screen/splash_screen.dart';
import 'package:mealtrips/fooddel/services/Authentication.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/size_config.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/theme.dart';
import 'package:provider/provider.dart';

// import 'package:image_picker/image_picker.dart';
class VendorProfile extends StatefulWidget {
  final VendorModel vendour;
  final String screen;
  VendorProfile(this.vendour, this.screen);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<VendorProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  AuthImplementation auth = Auth();

   bool _light = false;


  _switchFunction(bool value) {
    setState(() {
      _light = value;
    });
  }
  
  File file;
  int catIndex;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.vendour.name;
    addressController.text = widget.vendour.address;
    phoneController.text = widget.vendour.phone;
    accountNameController.text = widget.vendour.accountName;
    accountNumberController.text = widget.vendour.accountNumber;
    bankNameController.text = widget.vendour.bankName;
  }

  void updateVendorInfo() {
    resturantRef.doc(widget.vendour.id).update({
      "address": addressController.text,
      "phone": phoneController.text,
      "name": nameController.text,
      "bankName": bankNameController.text,
      "accountNumber": accountNumberController.text,
      "accountName": accountNameController.text,
    });
    SnackBar snackBar = SnackBar(content: Text("Profile updated"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
   
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:  widget.screen == "Admin" ? true : false,
         backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).textSelectionColor),
        title:  Text(
          'Profile',
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.screenWidth * 0.04,
          ),
        ),
        actions: [
          widget.screen == "Admin"
              ? SizedBox.shrink()
              : IconButton(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProfilePicture(widget.vendour.id, "", "", 1)))),
                               widget.screen == "Admin"
                            ? SizedBox.shrink()
                            : IconButton(
                                icon: Icon(Icons.logout),
                                onPressed: ()async{
                                  //Turn off dark mode
                                if(themeProvider.isDarkMode){
                                  final provider = Provider.of<ThemeProvider>(context, listen: false);
                                  provider.toggleTheme(false);
                                }

                           await auth.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) => SplashScreen()),
                                (Route<dynamic> route) => false);
                                
                          },
                  ),
          SizedBox(width: 20.0),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 80,
                        child: CircleAvatar(
                            radius: 80.0,
                            backgroundColor: Colors.white,
                            child: Hero(
                                tag: widget.vendour.image,
                                child: GestureDetector(
                                  onTap: () =>
                                      photoPreview(context, widget.vendour.image),
                                  child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        widget.vendour.image),
                                    radius: 70.0,
                                    backgroundColor: Colors.grey[300],
                                  ),
                                ))),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      buildNameFormField(context),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      buildAddressFormField(context),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      buildPhoneFormField(context),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      buildBankNameFormField(context),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      builAccountNameField(context),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      buildAccountNumberFormField(context),
                    ],
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(5),
                ),
                widget.screen == "Admin"
                    ? SizedBox.shrink()
                    : Column(
                      children: [
                        DefaultButton(
                            press: () {
                              updateVendorInfo();
                            },
                            text: 'Update',
                          ),
                SizedBox(height: getProportionateScreenHeight(20)),
            
            
                      ],
                    ),
               
              
              ],
            ),
          ),
        ),
      ),
    );
  }

  photoPreview(BuildContext context, String photo) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhotoPreview(photo)));
  }

  TextFormField buildNameFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: nameController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Resturant name',
        suffixIcon: Icon(Icons.label),
        labelText: 'name',
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

  TextFormField buildAddressFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: addressController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Resturant Address',
        labelText: 'Address',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        focusColor: kPrimaryColor,
        suffixIcon: Icon(Icons.location_on),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getProportionateScreenWidth(30)),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
          gapPadding: 0,
        ),
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

  TextFormField buildPhoneFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: phoneController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Phone number',
        labelText: 'Phone number',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        suffixIcon: Icon(Icons.phone),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getProportionateScreenWidth(30)),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
          gapPadding: 0,
        ),
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

  TextFormField buildBankNameFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: bankNameController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Bank Name',
        labelText: 'Bank name',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        suffixIcon: Icon(Icons.label),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getProportionateScreenWidth(30)),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
          gapPadding: 0,
        ),
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

  TextFormField buildAccountNumberFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: accountNumberController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Account Number',
        labelText: 'Account Number',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        suffixIcon: Icon(Icons.label),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getProportionateScreenWidth(30)),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
          gapPadding: 0,
        ),
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

  TextFormField builAccountNameField(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: accountNameController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Account name',
        labelText: 'Account name',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        suffixIcon: Icon(Icons.label),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getProportionateScreenWidth(30)),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
          gapPadding: 0,
        ),
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
