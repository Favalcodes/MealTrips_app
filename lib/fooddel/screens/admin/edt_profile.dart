import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/fooddel/components/default_buttons.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/profile_picture/photo_preview.dart';
import 'package:mealtrips/fooddel/screens/profile_picture/profile_picture.dart';
import 'package:mealtrips/fooddel/screens/splash_screen/splash_screen.dart';
import 'package:mealtrips/fooddel/services/Authentication.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/size_config.dart';


// import 'package:image_picker/image_picker.dart';
class AdminProfile extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<AdminProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  AuthImplementation auth = Auth();
  
  File file;
  int catIndex;

  @override
  void initState() {
    super.initState();
    nameController.text = onlineUser.name;
    addressController.text = onlineUser.address;
    phoneController.text = onlineUser.phone;
  }

  void updateVendorInfo() {
    usersReference.doc(onlineUser.id).update({
      "phone": phoneController.text,
      "name": nameController.text,
    });
    SnackBar snackBar = SnackBar(content: Text("Profile updated"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:  false,
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
        IconButton(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProfilePicture(onlineUser.id, "", "", 0)))),
                 IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: ()async{
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
                                tag: onlineUser.image,
                                child: GestureDetector(
                                  onTap: () =>
                                      photoPreview(context, onlineUser.image),
                                  child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        onlineUser.image),
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
                    
                      buildPhoneFormField(context),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(5),
                ),
               Column(
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

 
}
