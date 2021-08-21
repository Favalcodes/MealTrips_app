import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:intl/intl.dart';

var formatter = new DateFormat("yyyy-MM-dd");
String now = formatter.format(DateTime.now());

Future<void> registerUser(String userId, String name, String email,
    String phone, int catIndex) async {
  DocumentSnapshot documentSnapshot = await usersReference.doc(userId).get();
  if (!documentSnapshot.exists) {
    usersReference.doc(userId).set({
      'name': name,
      'phone': phone,
      'email': email,
      'type': catIndex,
      'address': "",
      'image': "",
      'date': now,
      'subDate': "",
      'token': ""
    });
  }
}

Future<void> vendourReg(String userId, String vendourName, String vendorAddress,
    String email, String phone) async {
  DocumentSnapshot documentSnapshot = await resturantRef.doc(userId).get();
  if (!documentSnapshot.exists) {
    resturantRef.doc(userId).set({
      'name': vendourName,
      'phone': phone,
      'email': email,
      'rating': 0.0,
      'address': vendorAddress,
      'userOrder': {},
      'rateId': {},
      'image': "",
      'subDate': now,
      'premium': true,
      'plan': 0,
      'date': now,
      'bankName': "",
      'accountName': "",
      'accountNumber': "",
      'balance': 0.0,
    });
  }
}

Future<void> deliveryReg(String userId, String deliveryName,
    String deliveryAddress, String email, String phone) async {
  DocumentSnapshot documentSnapshot = await deliveryRef.doc(userId).get();
  if (!documentSnapshot.exists) {
    deliveryRef.doc(userId).set({
      'name': deliveryName,
      'phone': phone,
      'email': email,
      'rating': 0.0,
      'address': deliveryAddress,
      "userOrder": {},
      'rateId': {},
      'image': "",
      'subDate': "",
      'premium': false,
      'plan': 0,
      'date': now,
      'bankName': "",
      'accountName': "",
      'accountNumber': "",
      'balance': 0.0,
    });
  }
}
