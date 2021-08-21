import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/fooddel/data/model/user_model.dart';
import 'package:mealtrips/fooddel/data/model/vendor_model.dart';
import 'package:mealtrips/fooddel/screens/splash_screen/splash_screen.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';

class UserRepo {
  Future<UserModel> getUser(BuildContext context) async {
    UserModel currentUser;
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User user = _firebaseAuth.currentUser;
    String userID = user.uid;
    await usersReference.doc(userID).get().then((value) {
      if (!value.exists) {
        user.delete();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => SplashScreen()),
            (Route<dynamic> route) => false);
      }
      currentUser = UserModel.fromDocument(value);
      return currentUser;
    });
    return currentUser;
  }

  Future<List<UserModel>> getUsers() async {
    List<UserModel> currentUser;
    await usersReference.get().then((value) {
      currentUser = value.docs
          .map((document) => UserModel.fromDocument(document))
          .toList();
      return currentUser;
    });
    return currentUser;
  }

  Future<UserModel> customerDetails(String userId) async {
    UserModel currentUser;
    await usersReference.doc(userId).get().then((value) {
      currentUser = UserModel.fromDocument(value);
      return currentUser;
    });
    return currentUser;
  }

  Future<VendorModel> getVendor(String userId) async {
    VendorModel Vendor;
    await resturantRef.doc(userId).get().then((value) {
      Vendor = VendorModel.fromDocument(value);
      return Vendor;
    });
    return Vendor;
  }

  Future<List<VendorModel>> getVendors() async {
    List<VendorModel> Vendor;
    await resturantRef.orderBy("rating", descending: true).get().then((value) {
      Vendor = value.docs
          .map((document) => VendorModel.fromDocument(document))
          .toList();
      return Vendor;
    });
    return Vendor;
  }

  Future<VendorModel> getDelivery(String userId) async {
    VendorModel delivery;
    await deliveryRef.doc(userId).get().then((value) {
      delivery = VendorModel.fromDocument(value);
      return delivery;
    });
    return delivery;
  }

  Future<List<VendorModel>> getAllDeliveryMerchant() async {
    List<VendorModel> delivery;
    await deliveryRef.get().then((value) {
      delivery = value.docs
          .map((document) => VendorModel.fromDocument(document))
          .toList();
      return delivery;
    });
    return delivery;
  }
}
